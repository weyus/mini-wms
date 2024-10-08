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

  def receive(conn, %{"id" => id, "inventory" => inventory_params}) do
    with {:ok} <- handle_negative_quantity(inventory_params["quantity"])
    do
      inventory = Repo.get(Inventory, id)
      with {:ok, inventory} <- modify_inventory(inventory, inventory_params["quantity"])
        do
        conn
        |> put_status(:ok)
        |> render(:show, inventory: inventory)
      else
        _err ->
        handle_error(conn, "Attempt to receive inventory failed")
      end
    else
      {:error, error_msg} ->
      handle_error(conn, error_msg)
    end
  end

  # This will transfer quantity of product from one location to another
  # If the from location has less than the requested quantity, it will transfer all that is available
  #
  # @return updated inventory at the to location
  def transfer(conn, %{"from_location_id" => from_location_id,
                       "to_location_id" => to_location_id,
                       "product_id" => product_id,
                       "quantity" => quantity}) do
    with {:ok, from_inventory, to_inventory, quantity} <- check_transfer_params(from_location_id,
                                                                                to_location_id,
                                                                                product_id,
                                                                                String.to_integer(quantity))
    do
      with {:ok, updated_to_inventory} <- Repo.transaction(fn ->
                                            modify_inventory(from_inventory, -quantity)
                                            {:ok, result} = modify_inventory(to_inventory, quantity)
                                            result
                                          end)
      do
        conn
        |> put_status(:ok)
        |> render(:show, %{inventory: updated_to_inventory})
      end
    else
      {:error, error_msg} ->
      handle_error(conn, error_msg)
    end
  end

  defp handle_negative_quantity(quantity) do
     if quantity <= 0, do: {:error, "Quantity must be greater than or equal to 0"}, else: {:ok}
  end

  defp check_transfer_params(from_location_id, to_location_id, product_id, quantity) do
    # WG - This could be better constructed,
    # would prefer not to pull these just to find out that the location ids are not the same.
    from_inventory = Repo.get_by(Inventory, location_id: from_location_id, product_id: product_id)
    to_inventory = Repo.get_by(Inventory, location_id: to_location_id, product_id: product_id)

    cond do
      from_inventory == nil ->
        {:error, "Inventory must exist in the from location"}
      to_inventory == nil ->
        {:error, "Inventory must exist in the to location"}
      from_location_id == to_location_id ->
        {:error, "From and to inventory locations must be different"}
      from_inventory.quantity == 0 ->
        {:error, "From location must have inventory"}
      # Normalize quantity if necessary - we can't take out more than is there
      from_inventory.quantity < quantity ->
        {:ok, from_inventory, to_inventory, from_inventory.quantity}
      true ->
        {:ok, from_inventory, to_inventory, quantity}
    end
  end

  defp modify_inventory(inventory, quantity) do
    inventory_quantity = inventory.quantity + quantity
    updated_inventory = inventory |> Map.put(:quantity, inventory_quantity)

    Inventory.changeset(inventory, Map.from_struct(updated_inventory))
    |> Repo.update()

    {:ok, updated_inventory}
  end

  defp handle_error(conn, error_msg) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: error_msg})
  end
end
