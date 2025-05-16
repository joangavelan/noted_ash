defmodule NotedWeb.AppController do
  use NotedWeb, :controller

  def index(conn, _params) do
    render_inertia(conn, "App")
  end
end
