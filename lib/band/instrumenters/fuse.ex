defmodule Band.Instrumenters.Fuse do
  @behaviour :fuse_stats_plugin

  @spec init(name::atom()) :: :ok
  def init(_name), do: :ok

  @spec increment(name :: atom(), counter :: :ok | :blown | :melt) :: :ok
  def increment(name, counter) do
    case counter do
      :ok ->
        Band.increment("fuse.ok", 1, tags: tags(name))
      :blown ->
        Band.increment("fuse.blown", 1, tags: tags(name))
      :melt ->
        Band.increment("fuse.melted", 1, tags: tags(name))
    end
  end

  defp tags(name), do: ["name:#{name}"]
end
