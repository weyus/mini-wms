defmodule TavoroMiniWmsWeb.InventoryController do
  use TavoroMiniWmsWeb, :controller

  alias TavoroMiniWms.Inventory

  alias TavoroMiniWms.Repo

  action_fallback TavoroMiniWmsWeb.FallbackController

  import Ecto.Query
  import TavoroMiniWms.Utility

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

  # This will receive a positive quantity of product into a location
  #
  # Assumptions:
  # 1. The inventory record exists
  #
  # Potential improvements:
  # 1. Allow for creation of a new inventory record if it doesn't exist (upsert - https://hexdocs.pm/ecto/constraints-and-upserts.html#upserts)
  #
  # @param conn Phoenix connection
  # @param params Map of: id, inventory
  # @return updated inventory at the to location
  def receive(conn, %{"id" => id, "inventory" => inventory_params}) do
    with {:ok} <- handle_negative_quantity(inventory_params["quantity"])
    do
      inventory = Repo.get(Inventory, id)
      if inventory == nil do
        handle_error(conn, "Inventory must exist")
      else
        with {:ok, inventory} <- modify_inventory(inventory, inventory_params["quantity"])
          do
          conn
          |> put_status(:ok)
          |> render(:show, inventory: inventory)
        else
          _err ->
          handle_error(conn, "Attempt to receive inventory failed")
        end
      end
    else
      {:error, error_msg} ->
      handle_error(conn, error_msg)
    end
  end

  # This will transfer quantity of product from one location to another
  # If the from location has less than the requested quantity, it will transfer all that is available
  #
  # Assumptions:
  # 1. The from and to locations are different
  # 2. The from location exists and has the product
  # 3. The to location exists and has the product
  #
  # Potential improvements:
  # 1. Allow for creation of a new to inventory record if it doesn't exist
  # 2. Return both from and to inventory records in response to show that transfer was successful
  #
  # @param conn Phoenix connection
  # @param params Map of: from_location_id, to_location_id, product_id, quantity
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
    if from_location_id == to_location_id do
      {:error, "From and to inventory locations must be different"}
    else
      from_inventory = Repo.get_by(Inventory, location_id: from_location_id, product_id: product_id)
      to_inventory = Repo.get_by(Inventory, location_id: to_location_id, product_id: product_id)

      cond do
        from_inventory == nil ->
          {:error, "Inventory must exist in the from location"}
        to_inventory == nil ->
          {:error, "Inventory must exist in the to location"}
        from_inventory.quantity == 0 ->
          {:error, "From location must have inventory"}
        # Normalize quantity if necessary - we can't take out more than is there
        from_inventory.quantity < quantity ->
          {:ok, from_inventory, to_inventory, from_inventory.quantity}
        true ->
          {:ok, from_inventory, to_inventory, quantity}
      end
    end
  end

  defp modify_inventory(inventory, quantity) do
    inventory_quantity = inventory.quantity + quantity
    updated_inventory = inventory |> Map.put(:quantity, inventory_quantity)

    Inventory.changeset(inventory, Map.from_struct(updated_inventory))
    |> Repo.update()

    {:ok, updated_inventory}
  end
end
