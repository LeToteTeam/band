defmodule Metrix.Instrumenters.Fuse do
  @behaviour :fuse_stats_plugin

  alias Metrix.Stats

  @spec init(name::atom()) :: :ok
  def init(_name), do: :ok

  @spec increment(name :: atom(), counter :: :ok | :blown | :melt) :: :ok
  def increment(name, counter) do
    case counter do
      :ok ->
        Stats.increment("fuse.ok", 1, tags: tags(name))
      :blown ->
        Stats.increment("fuse.blown", 1, tags: tags(name))
      :melt ->
        Stats.increment("fuse.melted", 1, tags: tags(name))
    end
  end

  defp tags(name), do: ["name:#{name}"]
end
