defmodule TavoroMiniWmsWeb.Router do
  use TavoroMiniWmsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TavoroMiniWmsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", TavoroMiniWmsWeb do
    pipe_through :api

    get "/products", ProductController, :index
    get "/products/:id", ProductController, :show
    put "/products/:id", ProductController, :update
    post "/products", ProductController, :create
    delete "/products/:id", ProductController, :delete

    get "/locations", LocationController, :index
    get "/locations/:id", LocationController, :show
    put "/locations/:id", LocationController, :update
    post "/locations", LocationController, :create
    delete "/locations/:id", LocationController, :delete
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tavoro_mini_wms, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TavoroMiniWmsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/" do
    forward "/", ReverseProxyPlug,
      upstream: "http://localhost:5173",
      error_callback: &TavoroMiniWmsWeb.reverse_proxy_error_callback/1,
      response_mode: :buffer
  end
end
