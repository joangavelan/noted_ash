defmodule NotedWeb.Serializers do
  def serialize_user(user) when is_map(user) do
    Map.take(user, [:id, :name, :email, :picture])
  end

  def serialize_user(_), do: nil
end
