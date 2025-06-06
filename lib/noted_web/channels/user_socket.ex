defmodule NotedWeb.UserSocket do
  use Phoenix.Socket

  channel "workspace:*", NotedWeb.WorkspaceChannel
  channel "user:*", NotedWeb.UserChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    # max_age: 1209600 is equivalent to two weeks in seconds
    case Phoenix.Token.verify(socket, "user salt", token, max_age: 1_209_600) do
      {:ok, user_id} ->
        {:ok, assign(socket, :current_user_id, user_id)}

      {:error, _reason} ->
        :error
    end
  end

  @impl true
  def id(_socket), do: nil
end
