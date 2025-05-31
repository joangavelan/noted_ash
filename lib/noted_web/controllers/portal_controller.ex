defmodule NotedWeb.PortalController do
  use NotedWeb, :controller

  import NotedWeb.Serializers

  alias Noted.Workspace

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    teams = Workspace.list_user_teams!(actor: current_user)
    invitations = Workspace.list_received_invitations!(actor: current_user)

    conn
    |> assign_prop(:teams, serialize_teams(teams))
    |> assign_prop(:invitations, serialize_invitations_received(invitations))
    |> render_inertia("Portal")
  end
end
