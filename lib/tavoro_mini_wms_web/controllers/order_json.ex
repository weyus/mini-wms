defmodule TavoroMiniWmsWeb.OrderJSON do
  alias TavoroMiniWms.Order
  alias TavoroMiniWms.OrderLine

  @doc """
  Renders a list of orders.
  """
  def index(%{orders: orders}) do
    %{data: for(order <- orders, do: data(order))}
  end

  @doc """
  Renders a single inventory.
  """
  def show(%{order: order}) do
    %{data: data(order)}
  end

  defp data(%Order{} = order) do
    order_lines = for line <- order.order_lines, do: line_data(line)
    %{
      id: order.id,
      customer_id: order.customer_id,
      customer_order_id: order.customer_order_id,
      state: order.state,
      shipment_method: order.shipment_method,
      shipment_id: order.shipment_id,
      order_lines: order_lines
    }
  end

  defp line_data(%OrderLine{} = line) do
    %{
      id: line.id,
      product_id: line.product_id,
      quantity: line.quantity
    }
  end
end
