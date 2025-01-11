defmodule TavoroMiniWmsWeb.OrderControllerTest do
  use TavoroMiniWmsWeb.ConnCase

  alias TavoroMiniWms.Product
  alias TavoroMiniWms.Repo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:setup_attrs]

    test "lists all orders if nothing is in the DB", %{conn: conn} do
      conn = get(conn, ~p"/api/orders")
      assert json_response(conn, 200)["data"] == []
    end

    test "show order line summaries on order list", %{conn: conn, create_attrs: create_attrs} do
      # Create an order
      conn = post(conn, ~p"/api/orders", order: create_attrs)

      conn = get(conn, ~p"/api/orders")
      response = json_response(conn, 200)["data"]
      first_order = Enum.at(response, 0)

      assert Enum.count(response) == 1
      assert first_order["order_lines"] == nil
      assert first_order["num_order_lines"] == 2
    end
  end

  describe "create" do
    setup [:setup_attrs]

    test "order is created with all order lines", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, ~p"/api/orders", order: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/orders/#{id}")

      response = json_response(conn, 200)["data"]
      assert %{
               "id" => ^id,
               "customer_id" => 1,
               "customer_order_id" => "XYZ",
               "state" => "RECEIVED",
               "shipment_id" => nil,
               "shipment_method" => "UPS",
             } = response
      assert Enum.count(response["order_lines"]) == 2
      assert Enum.all?(response["order_lines"], fn line ->
        line["id"] > 0 &&
        line["product_id"] > 0 &&
        (line["quantity"] == 2 || line["quantity"] == 3)
      end)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/orders", order: %{})
      response = json_response(conn, 400)["error"]
      assert response == "Failed to create order"
    end
  end

  # Unfinished fulfill tests
  describe "fulfill" do
    setup [:setup_attrs]

    @tag :skip
    test "changes order status from RECEIVED to PICKED when fulfill is successful", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, ~p"/api/orders", order: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = post(conn, ~p"/api/orders/#{id}/fulfill")
      response = json_response(conn, 200)["data"]
      assert response["state"] == "PICKED"
    end

    @tag :skip
    test "successfully decreases inventory for all order lines", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, ~p"/api/orders", order: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = post(conn, ~p"/api/orders/#{id}/fulfill")
      response = json_response(conn, 200)["data"]

      # Fix these assertions
      assert Enum.all?(response["order_lines"], fn line ->
        line["quantity"] == 0
      end)
    end

    @tag :skip
    test "returns an error if not all order lines can be fulfilled", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, ~p"/api/orders", order: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = post(conn, ~p"/api/orders/#{id}/fulfill")
      response = json_response(conn, 200)["data"]

      # Fix these assertions
      assert Enum.all?(response["order_lines"], fn line ->
        line["quantity"] == 0
      end)
    end

    @tag :skip
    test "doesn't allow two order fulfills to cause double inventory reduction", %{conn: conn, create_attrs: create_attrs} do
    end
  end

  defp setup_attrs(_) do
    %Product{id: product_id1} = Repo.insert!(%Product{name: "some name", price: 120.5, sku: "12345"})
    %Product{id: product_id2} = Repo.insert!(%Product{name: "some other name", price: 999.99, sku: "X2C4B"})

    %{create_attrs: %{customer_id: 1,
                      customer_order_id: "XYZ",
                      shipment_method: "UPS",
                      lines: [
                        %{product_id: product_id1, quantity: 2},
                        %{product_id: product_id2, quantity: 3}
                      ]}
    }
  end
end