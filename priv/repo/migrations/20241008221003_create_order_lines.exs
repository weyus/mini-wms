defmodule TavoroMiniWms.Repo.Migrations.CreateOrderLines do
  use Ecto.Migration

  def change do
    create table(:order_lines) do
      add :quantity, :integer
      add :order_id, references(:orders, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create constraint("order_lines", :quantity_must_be_positive, check: "quantity > 0")
    create index(:order_lines, [:order_id])
    create index(:order_lines, [:product_id])
  end
end
