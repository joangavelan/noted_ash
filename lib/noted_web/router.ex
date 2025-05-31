defmodule NotedWeb.Router do
  use NotedWeb, :router

  import NotedWeb.UserAuth
  import NotedWeb.TenantAuth

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

    get "/portal", PortalController, :index
    get "/teams/new", WorkspaceController, :new
    post "/teams", WorkspaceController, :create
    post "/enter-workspace", WorkspaceController, :enter
    delete "/decline-invitation", WorkspaceController, :decline_invitation
    post "/accept-invitation", WorkspaceController, :accept_invitation
  end

  scope "/workspace", NotedWeb do
    pipe_through [
      :browser,
      :require_authenticated_user,
      :ensure_tenant,
      :load_user_role,
      :set_permissions
    ]

    get "/", WorkspaceController, :show
    get "/search-users", WorkspaceController, :search_users
    post "/invite-user", WorkspaceController, :invite_user
    delete "/cancel-invitation", WorkspaceController, :cancel_invitation
    delete "/remove-team-member", WorkspaceController, :remove_team_member
    delete "/leave-team", WorkspaceController, :leave_team
    delete "/delete-team", WorkspaceController, :delete_team
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
