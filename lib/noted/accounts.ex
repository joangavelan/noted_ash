defmodule Noted.Accounts do
  use Ash.Domain,
    otp_app: :noted

  resources do
    resource Noted.Accounts.Token
    resource Noted.Accounts.User
  end
end
