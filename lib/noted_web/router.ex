defmodule NotedWeb.Router do
  use NotedWeb, :router

  import NotedWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NotedWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug Inertia.Plug
  end

  scope "/", NotedWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", NotedWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/login", UserSessionController, :new
    post "/login", UserSessionController, :create
  end

  scope "/auth", NotedWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/:provider", OAuth2Controller, :request
    get "/:provider/callback", OAuth2Controller, :callback
  end

  scope "/", NotedWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/app", AppController, :index
  end

  scope "/", NotedWeb do
    pipe_through :browser

    delete "/logout", UserSessionController, :delete
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:noted, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NotedWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
