defmodule NotedWeb.WorkspaceController do
  use NotedWeb, :controller

  import NotedWeb.Serializers

  alias Noted.Accounts
  alias Noted.Workspace

  def new(conn, _params) do
    render_inertia(conn, "Teams/New")
  end

  def create(conn, params) do
    current_user = conn.assigns.current_user

    case Workspace.create_team(params, actor: current_user) do
      {:ok, _team} ->
        conn
        |> put_flash(:success, "Team created successfully!")
        |> redirect(to: ~p"/portal")

      {:error, error} ->
        conn
        |> assign_errors(error)
        |> redirect(to: ~p"/teams/new")
    end
  end

  def enter(conn, %{"team_id" => team_id}) do
    conn
    |> put_session(:team_id, team_id)
    |> redirect(to: ~p"/workspace")
  end

  def show(conn, _params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    team_members =
      Workspace.list_team_members!(
        load: [:can_manage],
        actor: current_user,
        tenant: current_team
      )

    invitations_sent = Workspace.list_invitations_sent!(actor: current_user, tenant: current_team)

    notes = Workspace.list_notes!(actor: current_user, tenant: current_team)

    conn
    |> assign_prop(:team_members, serialize_team_members(team_members))
    |> assign_prop(:invitations_sent, serialize_invitations_sent(invitations_sent))
    |> assign_prop(:notes, serialize_listed_notes(notes))
    |> render_inertia("Workspace")
  end

  def search_users(conn, params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team
    users = Accounts.search_users!(params, actor: current_user, tenant: current_team)

    json(conn, serialize_user_search_results(users))
  end

  def invite_user(conn, params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    case Workspace.invite_user(params, actor: current_user, tenant: current_team) do
      {:ok, _invitation} ->
        conn
        |> put_flash(:success, "Invitation sent!")
        |> redirect(to: ~p"/workspace")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while sending the invitation.")
        |> redirect(to: ~p"/workspace")
    end
  end

  def change_role(conn, params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    case Workspace.change_member_role(params["member_id"], %{role: params["role"]},
           actor: current_user,
           tenant: current_team
         ) do
      {:ok, _member} ->
        conn
        |> put_flash(:success, "Member role updated!")
        |> redirect(to: ~p"/workspace")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while updating the member role.")
        |> redirect(to: ~p"/workspace")
    end
  end

  def cancel_invitation(conn, params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    case Workspace.cancel_invitation(params, actor: current_user, tenant: current_team) do
      :ok ->
        conn
        |> put_flash(:warning, "Invitation canceled.")
        |> redirect(to: ~p"/workspace")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occured while canceling the invitation.")
        |> redirect(to: ~p"/workspace")
    end
  end

  def decline_invitation(conn, params) do
    current_user = conn.assigns.current_user

    case Workspace.decline_invitation(%{id: params["invitation_id"]},
           actor: current_user,
           tenant: params["team_id"]
         ) do
      :ok ->
        conn
        |> put_flash(:warning, "Invitation declined.")
        |> redirect(to: ~p"/portal")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occured while declining the invitation.")
        |> redirect(to: ~p"/portal")
    end
  end

  def accept_invitation(conn, params) do
    current_user = conn.assigns.current_user

    case Workspace.accept_invitation(%{id: params["invitation_id"]},
           actor: current_user,
           tenant: params["team_id"]
         ) do
      :ok ->
        conn
        |> put_flash(:success, "Invitation accepted!")
        |> redirect(to: ~p"/portal")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while accepting the invitation.")
        |> redirect(to: ~p"/portal")
    end
  end

  def remove_team_member(conn, params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    case Workspace.remove_team_member(params, actor: current_user, tenant: current_team) do
      :ok ->
        conn
        |> put_flash(:success, "Team member has been removed!")
        |> redirect(to: ~p"/workspace")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while removing the team member.")
        |> redirect(to: ~p"/workspace")
    end
  end

  def leave_team(conn, _params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    team_member =
      Workspace.get_member!(current_user.id, current_team.id,
        actor: current_user,
        tenant: current_team
      )

    case Workspace.leave_team(team_member, actor: current_user, tenant: current_team) do
      :ok ->
        conn
        |> put_flash(:info, "You just left the team!")
        |> redirect(to: ~p"/portal")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while leaving the team.")
        |> redirect(to: ~p"/workspace")
    end
  end

  def delete_team(conn, _params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    case Workspace.delete_team(current_team, actor: current_user) do
      :ok ->
        conn
        |> put_flash(:success, "Team deleted!")
        |> redirect(to: ~p"/portal")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while deleting the team.")
        |> redirect(to: ~p"/workspace")
    end
  end
end
