defmodule Metrix.Application do
  use Application

  def start(_type, _args) do
    :ok = Metrix.Stats.connect()

    children = [
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
