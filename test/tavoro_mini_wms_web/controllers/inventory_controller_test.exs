defmodule TavoroMiniWmsWeb.InventoryControllerTest do
  use TavoroMiniWmsWeb.ConnCase

  import Ecto.Query

  alias TavoroMiniWms.Product
  alias TavoroMiniWms.Location
  alias TavoroMiniWms.Inventory
  alias TavoroMiniWms.Repo

  @create_attrs %{
    quantity: 3
  }
  @receive_attrs %{
    quantity: 3
  }
  @bad_attrs %{
    quantity: -3
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "receive inventory" do
    setup [:create_inventory]

    test "renders error when quantity is < 0", %{conn: conn, inventory: inventory} do
      conn = put(conn, ~p"/api/inventories/receive/#{inventory.id}", inventory: @bad_attrs)

      response = json_response(conn, 400)["error"]
      assert response == "Quantity must be greater than or equal to 0"
    end

    test "renders error when inventory doesn't exist", %{conn: conn, inventory: inventory} do
      %Inventory{id: inventory.id} |> Repo.delete

      conn = put(conn, ~p"/api/inventories/receive/#{inventory.id}", inventory: @receive_attrs)

      response = json_response(conn, 400)["error"]
      assert response == "Inventory must exist"
    end

    # What is the value of doing the pattern matching in the parameter here?
    test "renders inventory when data is valid", %{conn: conn, inventory: %Inventory{id: id} = inventory} do
      conn = put(conn, ~p"/api/inventories/receive/#{inventory}", inventory: @receive_attrs)

      response = json_response(conn, 200)["data"]
      assert response["id"] == id
      assert response["quantity"] == 6
    end
  end

  describe "transfer inventory" do
    setup do
      create_inventory(true)
    end

    test "renders error when inventory in from_location_id is not present", %{conn: conn, inventory: inventory, inventory2: inventory2} do
      %Inventory{id: inventory.id} |> Repo.delete

      conn = put(conn, ~p"/api/inventories/transfer/#{inventory.location_id}/#{inventory2.location_id}/#{inventory.product_id}/5")

      response = json_response(conn, 400)["error"]
      assert response == "Inventory must exist in the from location"
    end

    test "renders error when inventory in to_location_id is not present", %{conn: conn, inventory: inventory, inventory2: inventory2} do
      %Inventory{id: inventory2.id } |> Repo.delete

      conn = put(conn, ~p"/api/inventories/transfer/#{inventory.location_id}/#{inventory2.location_id}/#{inventory.product_id}/5")

      response = json_response(conn, 400)["error"]
      assert response == "Inventory must exist in the to location"
    end

    test "renders error when location_ids are the same", %{conn: conn, inventory: inventory} do
      conn = put(conn, ~p"/api/inventories/transfer/#{inventory.location_id}/#{inventory.location_id}/#{inventory.product_id}/5")
      response = json_response(conn, 400)["error"]
      assert response == "From and to inventory locations must be different"
    end

    test "renders error when from quantity is 0", %{conn: conn, inventory: inventory, inventory2: inventory2} do
      updated_inventory = inventory |> Map.put(:quantity, 0)
      Inventory.changeset(inventory, Map.from_struct(updated_inventory))
      |> Repo.update()

      conn = put(conn, ~p"/api/inventories/transfer/#{inventory.location_id}/#{inventory2.location_id}/#{inventory.product_id}/5")
      response = json_response(conn, 400)["error"]
      assert response == "From location must have inventory"
    end

    test "renders inventory when data is valid and transfer amount is less than or equal to from amount", %{conn: conn, inventory: inventory, inventory2: inventory2} do
      conn = put(conn, ~p"/api/inventories/transfer/#{inventory.location_id}/#{inventory2.location_id}/#{inventory.product_id}/2")

      # To inventory location quantity
      response = json_response(conn, 200)["data"]
      assert response["quantity"] == 5

      # From inventory location quantity
      query = from i in Inventory, where: (i.id == ^inventory.id), select: i.quantity
      quantity = Repo.one query
      assert quantity == 1
    end

    test "renders inventory when data is valid and transfer amount is greater than from amount", %{conn: conn, inventory: inventory, inventory2: inventory2} do
      conn = put(conn, ~p"/api/inventories/transfer/#{inventory.location_id}/#{inventory2.location_id}/#{inventory.product_id}/5")

      # To inventory location quantity
      response = json_response(conn, 200)["data"]
      assert response["quantity"] == 6

      # From inventory location quantity
      query = from i in Inventory, where: (i.id == ^inventory.id), select: i.quantity
      quantity = Repo.one query
      assert quantity == 0
    end
  end

  defp create_inventory(transfer) do
    %Product{id: product_id} = Repo.insert!(%Product{name: "some name", price: 120.5, sku: "12345"})
    %Location{id: location_id} = Repo.insert!(%Location{name: "some name"})

    updated_attrs = Map.put(@create_attrs, :product_id, product_id)
                    |> Map.put(:location_id, location_id)

    inventory =
      Inventory.create_changeset(updated_attrs)
      |> Repo.insert!()

    inventory2 = if transfer do
                   %Location{id: location_id2} = Repo.insert!(%Location{name: "some name 2"})

                   updated_attrs = Map.put(@create_attrs, :product_id, product_id)
                                  |> Map.put(:location_id, location_id2)

                   Inventory.create_changeset(updated_attrs)
                   |> Repo.insert!()
                 end

    %{inventory: inventory, inventory2: inventory2}
  end
end