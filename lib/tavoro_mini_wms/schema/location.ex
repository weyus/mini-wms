defmodule TavoroMiniWms.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :name, :string

    timestamps()
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
