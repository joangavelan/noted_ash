defmodule Noted.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        Noted.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:noted, :token_signing_secret)
  end

  def secret_for(
        [:authentication, :strategies, :google, key],
        Noted.Accounts.User,
        _opts,
        _context
      ) do
    env_key =
      case key do
        :client_id -> :google_client_id
        :client_secret -> :google_client_secret
        :redirect_uri -> :google_redirect_uri
      end

    Application.fetch_env(:noted, env_key)
  end
end
