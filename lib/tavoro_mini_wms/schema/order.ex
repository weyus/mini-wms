defmodule TavoroMiniWms.Order do
  use Ecto.Schema

  import Ecto.Changeset

  alias TavoroMiniWms.OrderLine

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
end
