defmodule VanadoBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      VanadoBackend.Repo,
      # Start the Telemetry supervisor
      VanadoBackendWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: VanadoBackend.PubSub},
      # Start the Endpoint (http/https)
      VanadoBackendWeb.Endpoint
      # Start a worker by calling: VanadoBackend.Worker.start_link(arg)
      # {VanadoBackend.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VanadoBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VanadoBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
