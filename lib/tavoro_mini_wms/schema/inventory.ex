defmodule TavoroMiniWms.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventories" do
    field :quantity, :integer
    field :product_id, :id
    field :location_id, :id

    timestamps(type: :utc_datetime)
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
