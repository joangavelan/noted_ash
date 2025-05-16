defmodule Noted.Accounts do
  use Ash.Domain,
    otp_app: :noted

  resources do
    resource Noted.Accounts.Token

    resource Noted.Accounts.User do
      define :register_with_password
      define :register_with_google
      define :sign_in_with_password
    end
  end
end
