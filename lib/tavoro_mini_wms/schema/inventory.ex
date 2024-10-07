defmodule TavoroMiniWms.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  alias TavoroMiniWms.Product
  alias TavoroMiniWms.Location

  schema "inventories" do
    field :quantity, :integer

    timestamps(type: :utc_datetime)

    belongs_to :product, Product
    belongs_to :location, Location
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [:product_id, :location_id, :quantity])
    |> validate_required([:product_id, :location_id, :quantity])
  end
end
