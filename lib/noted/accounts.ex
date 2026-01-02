defmodule Noted.Accounts do
  use Ash.Domain,
    otp_app: :noted

  resources do
    resource Noted.Accounts.Token

    resource Noted.Accounts.User do
      define :register_with_password
      define :register_with_google
      define :sign_in_with_password
      define :search_users
      define :get_user_by_email, action: :read, get_by: :email
    end
  end

  def confirm_user(token) do
    Noted.Accounts.User
    |> AshAuthentication.Info.strategy!(:confirm_new_user)
    |> AshAuthentication.AddOn.Confirmation.Actions.confirm(%{"confirm" => token})
  end

  def generate_new_user_confirmation_token(user) do
    now = DateTime.utc_now()
    changeset = Ash.Changeset.for_update(user, :update, %{"confirmed_at" => now})

    Noted.Accounts.User
    |> AshAuthentication.Info.strategy!(:confirm_new_user)
    |> AshAuthentication.AddOn.Confirmation.confirmation_token(changeset, user)
  end

  def request_password_reset(email) do
    Noted.Accounts.User
    |> AshAuthentication.Info.strategy!(:password)
    |> AshAuthentication.Strategy.Password.Actions.reset_request(%{"email" => email}, [])
  end

  def reset_password(token, password, password_confirmation) do
    Noted.Accounts.User
    |> AshAuthentication.Info.strategy!(:password)
    |> AshAuthentication.Strategy.Password.Actions.reset(%{
      "reset_token" => token,
      "password" => password,
      "password_confirmation" => password_confirmation
    }, [])
  end
end
