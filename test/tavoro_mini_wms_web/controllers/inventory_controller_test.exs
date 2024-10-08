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
      conn = put(conn, ~p"/api/inventories/#{inventory.id}", inventory: @bad_attrs)
      response = json_response(conn, 400)["error"]
      assert response == "Quantity must be greater than or equal to 0"
    end

    test "renders inventory when data is valid", %{conn: conn, inventory: %Inventory{id: id} = inventory} do
      conn = put(conn, ~p"/api/inventories/#{inventory}", inventory: @receive_attrs)

      response = json_response(conn, 200)["data"]
      assert response["id"] == id
      assert response["quantity"] == 6
    end
  end

  defp create_inventory(_) do
    Repo.insert!(%Product{name: "some name", price: 120.5, sku: "12345"})
    query = from p in Product, select: max(p.id)
    product_id = Repo.one query

    Repo.insert!(%Location{name: "some name"})
    query = from l in Location, select: max(l.id)
    location_id = Repo.one query

    updated_attrs = Map.put(@create_attrs, :product_id, product_id)
                    |> Map.put(:location_id, location_id)

    inventory =
      Inventory.create_changeset(updated_attrs)
      |> Repo.insert!()

    %{inventory: inventory}
  end
end