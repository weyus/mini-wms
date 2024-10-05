defmodule TavoroMiniWmsWeb.LocationController do
  use TavoroMiniWmsWeb, :controller

  alias TavoroMiniWms.Location

  alias TavoroMiniWms.Repo

  action_fallback TavoroMiniWmsWeb.FallbackController

  import Ecto.Query

  def index(conn, _params) do
    locations = from(l in Location) |> Repo.all()
    render(conn, :index, locations: locations)
  end

  def create(conn, %{"location" => location_params}) do
    with {:ok, %Location{} = location} <-
           Location.create_changeset(location_params) |> Repo.insert() do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/locations/#{location}")
      |> render(:show, location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = Repo.get(Location, id)
    render(conn, :show, location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = Repo.get(Location, id)

    with {:ok, %Location{} = location} <-
           Location.changeset(location, location_params) |> Repo.update() do
      render(conn, :show, location: location)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = Repo.get(Location, id)

    with {:ok, %Location{}} <- Repo.delete(location) do
      send_resp(conn, :no_content, "")
    end
  end
end
