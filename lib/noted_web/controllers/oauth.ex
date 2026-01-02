defmodule NotedWeb.OAuth2Controller do
  use NotedWeb, :controller

  alias Assent.Strategy.Google
  alias NotedWeb.UserAuth
  alias Noted.Accounts

  defp config do
    [
      client_id: Application.get_env(:noted, :google_client_id),
      client_secret: Application.get_env(:noted, :google_client_secret),
      redirect_uri: Application.get_env(:noted, :google_redirect_uri)
    ]
  end

  def request(conn, %{"provider" => "google"}) do
    config()
    |> Google.authorize_url()
    |> case do
      {:ok, %{url: url, session_params: session_params}} ->
        conn
        |> put_session(:session_params, session_params)
        |> redirect(external: url)

      {:error, _error} ->
        conn
        |> put_flash(:error, "Something went wrong generating the request authorization url")
        |> redirect(to: ~p"/login")
    end
  end

  def callback(conn, %{"provider" => "google"} = params) do
    session_params = get_session(conn, :session_params)
    config = Keyword.put(config(), :session_params, session_params)

    with {:ok, credentials} <- Google.callback(config, params),
         {:ok, user} <-
           Accounts.register_with_google(
             %{user_info: credentials.user, oauth_tokens: credentials.token},
             authorize?: false
           ) do
      UserAuth.log_in(conn, user)
    else
      {:error, _error} ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: ~p"/login")
    end
  end
end
