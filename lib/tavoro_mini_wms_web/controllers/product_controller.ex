defmodule TavoroMiniWmsWeb.ProductController do
  use TavoroMiniWmsWeb, :controller

  alias TavoroMiniWms.Repo

  alias TavoroMiniWms.Product

  action_fallback TavoroMiniWmsWeb.FallbackController

  import Ecto.Query

  def index(conn, _params) do
    products = from(p in Product) |> Repo.all()
    render(conn, :index, products: products)
  end

  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- Product.create_changeset(product_params) |> Repo.insert() do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/products/#{product}")
      |> render(:show, product: product)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get(Product, id)
    render(conn, :show, product: product)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Repo.get(Product, id)

    with {:ok, %Product{} = product} <-
           Product.changeset(product, product_params) |> Repo.update() do
      render(conn, :show, product: product)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get(Product, id)

    with {:ok, %Product{}} <- Repo.delete(product) do
      send_resp(conn, :no_content, "")
    end
  end
end
