defmodule Band do
  use Statix, runtime_config: true
  use GenServer

  def child_spec(config) do
    %{id: __MODULE__,
      start: {__MODULE__, :start_link, [config]},
      restart: :temporary,
      type: :worker,
      shutdown: 5000}
  end

  def start_link(config) do
    GenServer.start_link(__MODULE__, config)
  end

  def init(config) do
    :band
    |> Application.get_all_env()
    |> Keyword.take([:prefix, :host, :port])
    |> Keyword.merge(config)
    |> Enum.each(fn {key, value} -> Application.put_env(:statix, key, value) end)

    Band.connect()

    :ignore
  end
end
