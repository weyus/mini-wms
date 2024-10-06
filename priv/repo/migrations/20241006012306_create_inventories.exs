defmodule TavoroMiniWms.Repo.Migrations.CreateInventories do
  use Ecto.Migration

  def change do
    create table(:inventories) do
      add :quantity, :integer
      add :product_id, references(:products, on_delete: :nothing)
      add :location_id, references(:locations, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:inventories, [:product_id])
    create index(:inventories, [:location_id])
  end
end
