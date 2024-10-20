defmodule TavoroMiniWms.Inventory do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias TavoroMiniWms.Repo
  alias TavoroMiniWms.Inventory
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

  # For this product and quantity requested, find all inventory records,
  # and remove inventory from as many as necessary by locking the records
  def get_inventory_for_product(product_id, requested_quantity) do
    query = from i in Inventory,
            where: i.product_id == ^product_id,
            group_by: i.id,
            having: sum(i.quantity) >= ^requested_quantity
    inventories = Repo.all(query)

    Enum.reduce(inventories, {:ok, 0}, fn inventory, {:ok, remaining_quantity} ->
      if remaining_quantity == 0 do
        {:ok, 0}
      else
        quantity_to_take = min(inventory.quantity, remaining_quantity)
        updated_inventory = inventory |> Map.put(:quantity, inventory.quantity - quantity_to_take)

        # This should lock the inventory record for update, and allow other updaters to wait
        get_and_lock_inventory(inventory.id)
        __MODULE__.changeset(inventory, Map.from_struct(updated_inventory))
        |> Repo.update()

        {:ok, remaining_quantity - quantity_to_take}
      end
    end)
  end

  def get_and_lock_inventory(inventory_id) do
    from i in Inventory,
    where: i.id == ^inventory_id,
    lock: "FOR UPDATE"
  end
end
