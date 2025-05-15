defmodule NotedWeb.PageControllerTest do
  use NotedWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert inertia_component(conn) == "home"
  end
end
