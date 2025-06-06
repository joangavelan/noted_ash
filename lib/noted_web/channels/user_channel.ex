defmodule NotedWeb.UserChannel do
  use NotedWeb, :channel

  @impl true
  def join("user:" <> user_id, _payload, socket) do
    current_user_id = socket.assigns.current_user_id

    if authorized?(user_id, current_user_id) do
      NotedWeb.Endpoint.subscribe("invitations:#{current_user_id}")
      NotedWeb.Endpoint.subscribe("members:#{current_user_id}")

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info(%{topic: "invitations:" <> _user_id}, socket) do
    push(socket, "invitations", %{})
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: "members:" <> _user_id, event: "remove_team_member"}, socket) do
    push(socket, "removed_from_team", %{})
    {:noreply, socket}
  end

  defp authorized?(user_id, current_user_id) do
    user_id == current_user_id
  end
end
