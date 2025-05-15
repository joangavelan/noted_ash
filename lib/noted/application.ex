defmodule Noted.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NotedWeb.Telemetry,
      Noted.Repo,
      {DNSCluster, query: Application.get_env(:noted, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Noted.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Noted.Finch},
      # Start a worker by calling: Noted.Worker.start_link(arg)
      # {Noted.Worker, arg},
      # Start to serve requests, typically the last entry
      NotedWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :noted]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Noted.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NotedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
