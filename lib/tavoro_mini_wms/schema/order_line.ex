defmodule TavoroMiniWms.OrderLine do
  use Ecto.Schema

  import Ecto.Changeset

  alias TavoroMiniWms.Order
  alias TavoroMiniWms.Product

  schema "order_lines" do
    field :quantity, :integer

    timestamps(type: :utc_datetime)

    belongs_to :order, Order
    belongs_to :product, Product
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @doc false
  def changeset(order_line, attrs) do
    order_line
    |> cast(attrs, [:order_id, :product_id, :quantity])
    |> validate_required([:order_id, :product_id, :quantity])
  end
end
