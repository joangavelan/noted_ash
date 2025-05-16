defmodule NotedWeb.UserSessionController do
  use NotedWeb, :controller

  alias Noted.Accounts
  alias NotedWeb.UserAuth

  def new(conn, _params) do
    render_inertia(conn, "Login")
  end

  def create(conn, params) do
    case Accounts.sign_in_with_password(params, authorize?: false) do
      {:ok, user} ->
        UserAuth.log_in(conn, user)

      {:error, _error} ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _params) do
    UserAuth.log_out(conn)
  end
end
