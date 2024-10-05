defmodule TavoroMiniWms.Repo do
  use Ecto.Repo,
    otp_app: :tavoro_mini_wms,
    adapter: Ecto.Adapters.Postgres
end
