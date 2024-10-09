defmodule TavoroMiniWms.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :customer_id, :integer, null: false  # This would be a foreign key to the customers table
      add :customer_order_id, :string, null: false
      add :state, :string, default: "RECEIVED", null: false
      add :shipment_method, :string
      add :shipment_id, :integer  # This would be a foreign key to the shipments table

      timestamps(type: :utc_datetime)
    end
  end
end
