defmodule TavoroMiniWms.Repo.Migrations.AddProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :sku, :string
      add :price, :decimal

      timestamps()
    end
  end
end
