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
end
