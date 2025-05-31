defmodule NotedWeb.UserConfirmationController do
  use NotedWeb, :controller

  alias Noted.Accounts
  alias Noted.Accounts.User.Senders.SendNewUserConfirmationEmail

  def edit(conn, %{"token" => token}) do
    conn
    |> assign_prop(:token, token)
    |> render_inertia("UserConfirmation")
  end

  def update(conn, %{"token" => token}) do
    case Accounts.confirm_user(token) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, "Your account has been confirmed successfully!")
        |> redirect(to: ~p"/login")

      {:error, _error} ->
        conn
        |> put_flash(:error, "The token is invalid or expired. Please request a new one.")
        |> redirect(to: ~p"/confirm-new-user")
    end
  end

  def new(conn, _params) do
    render_inertia(conn, "RequestNewUserConfirmationToken")
  end

  def create(conn, %{"email" => email}) do
    with {:ok, user} <- Accounts.get_user_by_email(email, authorize?: false),
         {:ok, token} <- Accounts.generate_new_user_confirmation_token(user) do
      SendNewUserConfirmationEmail.send(user, token, [])
    end

    conn
    |> put_flash(
      :info,
      "If your email exists in our system, you will receive a confirmation email."
    )
    |> redirect(to: ~p"/login")
  end
end
