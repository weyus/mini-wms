defmodule TavoroMiniWmsWeb.ProductControllerTest do
  use TavoroMiniWmsWeb.ConnCase

  alias TavoroMiniWms.Product

  alias TavoroMiniWms.Repo

  @create_attrs %{
    name: "some name",
    price: "120.5",
    sku: "some sku"
  }
  @update_attrs %{
    name: "some updated name",
    price: "456.7",
    sku: "some updated sku"
  }
  @invalid_attrs %{name: nil, price: nil, sku: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, ~p"/api/products")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "price" => "120.5",
               "sku" => "some sku"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put(conn, ~p"/api/products/#{product}", product: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "price" => "456.7",
               "sku" => "some updated sku"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, ~p"/api/products/#{product}", product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, ~p"/api/products/#{product}")
      assert response(conn, 204)

      # TODO: better error handling
      # assert_error_sent 404, fn ->
      #   get(conn, ~p"/api/products/#{product}")
      # end
    end
  end

  defp create_product(_) do
    product =
      Product.create_changeset(@create_attrs)
      |> Repo.insert!()

    %{product: product}
  end
end
