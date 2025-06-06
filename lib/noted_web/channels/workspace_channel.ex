defmodule NotedWeb.WorkspaceChannel do
  use NotedWeb, :channel

  @topics ~w(invitations notes members)

  @impl true
  def join("workspace:" <> team_id, _payload, socket) do
    user_id = socket.assigns.current_user_id

    if authorized?(user_id, team_id) do
      for t <- @topics do
        NotedWeb.Endpoint.subscribe("#{t}:#{team_id}")
      end

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  for topic <- @topics do
    @impl true
    def handle_info(%{topic: unquote(topic) <> _team_id}, socket) do
      push(socket, unquote(topic), %{})
      {:noreply, socket}
    end
  end

  defp authorized?(user_id, team_id) do
    Noted.Workspace."is_member?!"(user_id, tenant: team_id, authorize?: false)
  end
end
