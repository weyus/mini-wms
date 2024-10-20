defmodule TavoroMiniWmsWeb.OrderController do
  use TavoroMiniWmsWeb, :controller

  alias TavoroMiniWms.Order

  alias TavoroMiniWms.Repo

  action_fallback TavoroMiniWmsWeb.FallbackController

  import Ecto.Query
  import TavoroMiniWms.Utility

  def index(conn, _params) do
    query = from o in Order,
            left_join: ol in assoc(o, :order_lines),
            group_by: o.id,
            select_merge: %{order_line_count: count(ol.id)}
    orders = Repo.all(query)

    render(conn, :index, orders: orders)
  end

  def create(conn, %{"order" => order_params}) do
    with {:ok, %Order{} = order} <- Order.create_order(order_params)
    do
      conn
      |> put_status(:created)
      |> put_resp_header("order", ~p"/api/orders/#{order}")
      |> render(:show, order: order)
    else
      {_, error_msg} -> handle_error(conn, error_msg)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, :show, order: Order.order_with_lines(id))
  end

  # For the purposes of the exercise, assuming fulfilling means picking
  def fulfill(conn, %{"id" => id}) do
    with {:ok} <- Order.fulfill_order(id)
    do
      render(conn, :show, order: Repo.get(Order, id))
    else {:error, error_msg} ->
      handle_error(conn, error_msg)
    end
  end
end