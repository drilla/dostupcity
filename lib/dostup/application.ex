defmodule Dostup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Dostup.Worker.start_link(arg)
      # {Dostup.Worker, arg}
      DostupWeb.Endpoint,
      Dostup.Persistence.Repo

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dostup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
