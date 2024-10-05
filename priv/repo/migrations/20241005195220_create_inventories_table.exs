defmodule TavoroMiniWms.Repo.Migrations.CreateInventoriesTable do
  use Ecto.Migration

  def change do
    # Not thrilled with this table name, but I'm going to go with it WG
    create table(:inventories) do
      add :product_id, references(:products)
      add :location_id, references(:locations)
      add :quantity, :integer

      timestamps()
    end
  end
end
