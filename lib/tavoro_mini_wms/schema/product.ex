defmodule TavoroMiniWms.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :sku, :string
    field :price, :decimal

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :sku, :price])
    |> validate_required([:name, :sku, :price])
    |> validate_number(:price, greater_than: 0)
  end
end
