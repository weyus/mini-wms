defmodule TavoroMiniWmsWeb.InventoryController do
  use TavoroMiniWmsWeb, :controller

  alias TavoroMiniWms.Inventory

  alias TavoroMiniWms.Repo

  action_fallback TavoroMiniWmsWeb.FallbackController

  import Ecto.Query

  def index(conn, _params) do
    inventories = from(l in Inventory) |> Repo.all()
    render(conn, :index, inventories: inventories)
  end

  def create(conn, %{"inventory" => inventory_params}) do
    with {:ok, %Inventory{} = inventory} <-
           Inventory.create_changeset(inventory_params) |> Repo.insert() do
      conn
      |> put_status(:created)
      |> put_resp_header("inventory", ~p"/api/inventories/#{inventory}")
      |> render(:show, inventory: inventory)
    end
  end

  def show(conn, %{"id" => id}) do
    inventory = Repo.get(Inventory, id)
    render(conn, :show, inventory: inventory)
  end

#  Maybe we will want this later, but for now, let's have more control on updating.
#  def update(conn, %{"id" => id, "inventory" => inventory_params}) do
#    inventory = Repo.get(Inventory, id)
#
#    with {:ok, %Inventory{} = inventory} <-
#           Inventory.changeset(inventory, inventory_params) |> Repo.update() do
#      render(conn, :show, inventory: inventory)
#    end
#  end

  def delete(conn, %{"id" => id}) do
    inventory = Repo.get(Inventory, id)

    with {:ok, %Inventory{}} <- Repo.delete(inventory) do
      send_resp(conn, :no_content, "")
    end
  end

  # How to lock DB when doing Repo.update()?
  def receive(conn, %{"id" => id, "inventory" => inventory_params}) do
    with {:ok} <- handle_negative_quantity(inventory_params["quantity"])
    do
      with {:ok, %Inventory{} = inventory} <- modify_inventory(conn, id, inventory_params)
        do
        conn
        |> put_status(:ok)
        |> render(:show, inventory: inventory)
      else
        _err ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Attempt to receive inventory failed"})
      end
    else
      {:error, error_msg} ->
      conn
      |> put_status(:bad_request)
      |> json(%{error: error_msg})
    end
  end

  defp handle_negative_quantity(quantity) do
     if quantity <= 0, do: {:error, "Quantity must be greater than or equal to 0"}, else: {:ok}
  end

  defp modify_inventory(conn, id, inventory_params) do
    check_params(conn, inventory_params)

    inventory = Repo.get(Inventory, id)
    inventory_quantity = inventory.quantity + inventory_params["quantity"]
    updated_inventory = inventory |> Map.put(:quantity, inventory_quantity)

    Inventory.changeset(inventory, Map.from_struct(updated_inventory))
    |> Repo.update()

    {:ok, updated_inventory}
  end

  defp check_params(conn, inventory_params) do
    if inventory_params["quantity"] == 0 do
      handle_bad_params(conn, "Quantity must be non-zero")
    end
  end

  defp handle_bad_params(conn, error_msg) do
    conn
    |> put_status(:bad_request)
    |> put_view(html: TavoroMiniWmsWeb.ErrorHTML, json: TavoroMiniWmsWeb.ErrorJSON)
    |> render("error.json", %{errors: %{detail: error_msg}})
  end
end
