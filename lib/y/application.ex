defmodule Y.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      YWeb.Telemetry,
      Y.Repo,
      {DNSCluster, query: Application.get_env(:y, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Y.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Y.Finch},
      # Start a worker by calling: Y.Worker.start_link(arg)
      # {Y.Worker, arg},
      # Start to serve requests, typically the last entry
      YWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Y.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    YWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
