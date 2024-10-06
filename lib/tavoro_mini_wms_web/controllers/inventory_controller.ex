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

  def update(conn, %{"id" => id, "inventory" => inventory_params}) do
    inventory = Repo.get(Inventory, id)

    with {:ok, %Inventory{} = inventory} <-
           Inventory.changeset(inventory, inventory_params) |> Repo.update() do
      render(conn, :show, inventory: inventory)
    end
  end

  def delete(conn, %{"id" => id}) do
    inventory = Repo.get(Inventory, id)

    with {:ok, %Inventory{}} <- Repo.delete(inventory) do
      send_resp(conn, :no_content, "")
    end
  end
end
