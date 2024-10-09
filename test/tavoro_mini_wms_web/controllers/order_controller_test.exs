defmodule TavoroMiniWmsWeb.OrderControllerTest do
  use TavoroMiniWmsWeb.ConnCase

  alias TavoroMiniWms.Product
  alias TavoroMiniWms.Repo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    setup [:setup_attrs]

    test "order is created with all order lines", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, ~p"/api/orders", order: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/orders/#{id}")
      assert %{
               "id" => ^id,
               "customer_id" => 1,
               "customer_order_id" => "XYZ",
               "state" => "RECEIVED",
               "shipment_id" => nil,
               "shipment_method" => "UPS",
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "order is created without some lines if they have quantity of 0", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, ~p"/api/orders", order: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      # Show that only lines with quantity > 0 are included
      conn = get(conn, ~p"/api/orders/#{id}")
      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/orders", order: %{})
      response = json_response(conn, 400)["error"]
      assert response == "Invalid data"
    end
  end

  defp setup_attrs(_) do
    %Product{id: product_id1} = Repo.insert!(%Product{name: "some name", price: 120.5, sku: "12345"})
    %Product{id: product_id2} = Repo.insert!(%Product{name: "some other name", price: 999.99, sku: "X2C4B"})

    %{create_attrs: %{ customer_id: 1,
                       customer_order_id: "XYZ",
                       shipment_method: "UPS",
                       lines: [
                         %{product_id: product_id1, quantity: 2},
                         %{product_id: product_id2, quantity: 3}
                       ]
                     }}
  end
end