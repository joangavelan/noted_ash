defmodule Noted.Accounts.User.Senders.SendNewUserConfirmationEmail do
  @moduledoc """
  Sends an email for a new user to confirm their email address.
  """

  use AshAuthentication.Sender
  use NotedWeb, :verified_routes

  import Swoosh.Email

  alias Noted.Mailer

  @impl true
  def send(user, token, _) do
    new()
    # TODO: Replace with your email
    |> from({"noted-app", "noted-app@test.com"})
    |> to(to_string(user.email))
    |> subject("Confirm your email address")
    |> html_body(body(token: token))
    |> Mailer.deliver!()
  end

  defp body(params) do
    url = url(~p"/confirm-new-user/#{params[:token]}")

    """
    <p>Click this link to confirm your email:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
