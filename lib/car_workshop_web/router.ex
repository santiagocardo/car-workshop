defmodule CarWorkshopWeb.Router do
  use CarWorkshopWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CarWorkshopWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CarWorkshopWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CarWorkshopWeb do
    pipe_through [:browser, :authenticate_user]

    live "/", VehicleLive.Index, :new

    live "/vehicles/new", VehicleLive.Index, :new
    live "/vehicles/:id/edit", VehicleLive.Index, :edit

    live "/vehicles/:id", VehicleLive.Show, :show
    live "/vehicles/:id/show/edit", VehicleLive.Show, :edit

    live "/work-orders", WorkOrderLive.Index, :index
    live "/work-orders/new", WorkOrderLive.Index, :new
    live "/work-orders/new/:plate", WorkOrderLive.Index, :new
    live "/work-orders/:id/edit", WorkOrderLive.Index, :edit

    live "/work-orders/:id", WorkOrderLive.Show, :show
    live "/work-orders/:id/show/edit", WorkOrderLive.Show, :edit
    live "/work-orders/:id/show/complete", WorkOrderLive.Show, :complete

    live "/reports", ReportLive.Index, :index
    live "/reports/new", ReportLive.Index, :new
    live "/reports/:id/edit", ReportLive.Index, :edit

    live "/reports/:id", ReportLive.Show, :show
    live "/reports/:id/show/edit", ReportLive.Show, :edit

    live "/services", ServiceLive.Index, :index
    live "/services/new", ServiceLive.Index, :new
    live "/services/:id/edit", ServiceLive.Index, :edit
  end

  scope "/sessions", CarWorkshopWeb do
    pipe_through :browser

    resources "/", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", CarWorkshopWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CarWorkshopWeb.Telemetry
    end
  end
end
