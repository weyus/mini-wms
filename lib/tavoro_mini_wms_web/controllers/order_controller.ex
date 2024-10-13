defmodule TavoroMiniWmsWeb.OrderController do
  use TavoroMiniWmsWeb, :controller

  alias TavoroMiniWms.Order
  alias TavoroMiniWms.OrderLine

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
    with {:ok, %Order{} = order} <- Repo.transaction(fn ->
                                      Order.create_changeset(order_params) |> Repo.insert()
                                      |> case do
                                        {:ok, order} ->
                                          Enum.map(order_params["lines"], fn line_params ->
                                               line_params |> Map.put("order_id", order.id)
                                             end)
                                          |> Enum.map(fn line_params ->
                                               OrderLine.create_changeset(line_params)
                                               |> Repo.insert()
                                             end)
                                          Repo.preload(order, :order_lines)
                                        {:error, _} -> "Failed to create order"
                                      end
                                    end)
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
    order = Order
            |> preload(:order_lines)
            |> Repo.get(id)
    render(conn, :show, order: order)
  end
end