defmodule TavoroMiniWms.Location do
  use Ecto.Schema
  import Ecto.Changeset

  alias TavoroMiniWms.Inventory

  schema "locations" do
    field :name, :string

    timestamps()

    has_many :inventories, Inventory
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
