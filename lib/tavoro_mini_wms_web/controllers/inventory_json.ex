defmodule TavoroMiniWmsWeb.InventoryJSON do
  alias TavoroMiniWms.Inventory

  @doc """
  Renders a list of inventories.
  """
  def index(%{inventories: inventories}) do
    %{data: for(inventory <- inventories, do: data(inventory))}
  end

  @doc """
  Renders a single location.
  """
  def show(%{inventory: inventory}) do
    %{data: data(inventory)}
  end

  defp data(%Inventory{} = inventory) do
    %{
      id: inventory.id,
      product_id: inventory.product_id,
      location_id: inventory.location_id,
      quantity: inventory.quantity
    }
  end
end
