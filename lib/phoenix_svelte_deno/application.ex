defmodule PhoenixSvelteDeno.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {NodeJS.Supervisor, [path: LiveSvelte.SSR.NodeJS.server_path(), pool_size: 4]},
      PhoenixSvelteDenoWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:phoenix_svelte_deno, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixSvelteDeno.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixSvelteDeno.Finch},
      # Start a worker by calling: PhoenixSvelteDeno.Worker.start_link(arg)
      # {PhoenixSvelteDeno.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixSvelteDenoWeb.Endpoint,
      PhoenixSvelteDeno.TodoCache,
      {DenoRider, [main_module_path: "priv/svelte/server.js"]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixSvelteDeno.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixSvelteDenoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
