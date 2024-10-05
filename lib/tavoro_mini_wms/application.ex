defmodule TavoroMiniWms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TavoroMiniWmsWeb.Telemetry,
      TavoroMiniWms.Repo,
      {DNSCluster, query: Application.get_env(:tavoro_mini_wms, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TavoroMiniWms.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TavoroMiniWms.Finch},
      # Start a worker by calling: TavoroMiniWms.Worker.start_link(arg)
      # {TavoroMiniWms.Worker, arg},
      # Start to serve requests, typically the last entry
      TavoroMiniWmsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TavoroMiniWms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TavoroMiniWmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
