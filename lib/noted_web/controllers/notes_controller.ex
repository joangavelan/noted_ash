defmodule NotedWeb.NotesController do
  use NotedWeb, :controller

  import NotedWeb.Serializers

  alias Noted.Workspace

  def new(conn, _params) do
    render_inertia(conn, "Notes/New")
  end

  def create(conn, params) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    case Workspace.create_note(params, actor: current_user, tenant: current_team) do
      {:ok, _note} ->
        conn
        |> put_flash(:success, "Note created successfully!")
        |> redirect(to: ~p"/workspace")

      {:error, error} ->
        conn
        |> assign_errors(error)
        |> redirect(to: ~p"/workspace/notes/new")
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    note = Workspace.get_note!(id, actor: current_user, tenant: current_team)

    conn
    |> assign_prop(:note, serialize_note_for_editing(note))
    |> render_inertia("Notes/Edit")
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    case Workspace.update_note(id, note_params, actor: current_user, tenant: current_team) do
      {:ok, _note} ->
        conn
        |> put_flash(:success, "Note updated successfully.")
        |> redirect(to: ~p"/workspace")

      {:error, error} ->
        conn
        |> assign_errors(error)
        |> redirect(to: ~p"/workspace/notes/#{id}/edit")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    current_team = conn.assigns.current_team

    case Workspace.delete_note(id, actor: current_user, tenant: current_team) do
      :ok ->
        conn
        |> put_flash(:success, "Note deleted successfully!")
        |> redirect(to: ~p"/workspace")

      {:error, _error} ->
        conn
        |> put_flash(:error, "An error occurred while deleting the note.")
        |> redirect(to: ~p"/workspace")
    end
  end
end
