defmodule TavoroMiniWms.Order do
  use Ecto.Schema

  import Ecto.Changeset

  alias TavoroMiniWms.Repo
  alias TavoroMiniWms.OrderLine

  import Ecto.Query

  schema "orders" do
    field :state, Ecto.Enum, values: [:RECEIVED, :PICKING, :PICKED, :PACKING, :PACKED, :SHIPPING, :SHIPPED], default: :RECEIVED
    field :customer_id, :integer
    field :customer_order_id, :string
    field :shipment_method, :string
    field :shipment_id, :integer
    field :order_line_count, :integer, virtual: true

    timestamps(type: :utc_datetime)

    has_many(:order_lines, OrderLine)
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:customer_id, :customer_order_id, :state, :shipment_method, :shipment_id])
    |> validate_required([:customer_id, :customer_order_id, :state])
  end

  def create_order(order_params) do
    Repo.transaction(fn ->
      create_changeset(order_params) |> Repo.insert()
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
  end

  def fulfill_order(id) do
    order = Order
            |> preload(:order_lines)
            |> Repo.get(id)

    order
    |> Ecto.Changeset.change(state: :PICKED)
  end
end
