defmodule NotedWeb.UserPasswordResetController do
  use NotedWeb, :controller

  alias Noted.Accounts

  def new(conn, _params) do
    render_inertia(conn, "RequestPasswordReset")
  end

  def create(conn, %{"email" => email}) do
    # Always return success message to prevent email enumeration
    Accounts.request_password_reset(email)

    conn
    |> put_flash(
      :info,
      "If your email exists in our system, you will receive a password reset email."
    )
    |> redirect(to: ~p"/login")
  end

  def edit(conn, %{"token" => token}) do
    conn
    |> assign_prop(:token, token)
    |> render_inertia("PasswordReset")
  end

  def update(conn, %{"token" => token, "password" => password, "password_confirmation" => password_confirmation}) do
    case Accounts.reset_password(token, password, password_confirmation) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, "Your password has been reset successfully!")
        |> redirect(to: ~p"/login")

      {:error, _error} ->
        conn
        |> put_flash(:error, "The token is invalid or expired. Please request a new one.")
        |> redirect(to: ~p"/password-reset")
    end
  end
end
