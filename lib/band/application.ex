defmodule Band.Application do
  use Application

  def start(_type, _args) do
    :ok = Band.connect()

    children = [
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
