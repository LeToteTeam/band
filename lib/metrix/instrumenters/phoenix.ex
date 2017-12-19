defmodule Metrix.Instrumenters.Phoenix do
  alias Metrix.Stats

  def phoenix_controller_call(:start, compile, data) do
    Map.put(data, :compile, compile)
  end
  def phoenix_controller_call(:stop, time_diff, %{conn: conn}) do
    time = Stats.microseconds(time_diff)
    metric = "phoenix.controller.call_duration"
    tags = [controller(conn), action(conn)]
    Metrix.histogram(metric, time, tags: tags)
  end

  def phoenix_controller_render(:start, compile, data) do
    Map.put(data, :compile, compile)
  end
  def phoenix_controller_render(:stop, time_diff, %{view: view, template: template, conn: conn}) do
    time   = Stats.microseconds(time_diff)
    metric = "phoenix.controller.render_duration"
    tags   = [controller(conn), view(view), template(template)]
    Metrix.histogram(metric, time, tags: tags)
  end

  def phoenix_channel_join(:start, compile, data) do
    Map.put(data, :compile, compile)
  end
  def phoenix_channel_join(:stop, time_diff, %{socket: socket}) do
    time   = Stats.microseconds(time_diff)
    metric = "phoenix.channel.join"
    tags   = [channel(socket)]

    Metrix.histogram(metric, time, tags: tags)
  end

  def phoenix_channel_receive(:start, compile, data) do
    Map.put(data, :compile, compile)
  end
  def phoenix_channel_receive(:stop, time_diff, %{socket: socket, event: event}) do
    time   = Stats.microseconds(time_diff)
    metric = "phoenix.channel.receive"
    tags   = [channel(socket), handler(socket), event(event)]
    Metrix.histogram(metric, time, tags: tags)
  end

  defp controller(conn) do
    "controller:#{conn.private.phoenix_controller}"
  end

  def view(mod) do
    "view:#{mod}"
  end

  defp action(conn) do
    "action:#{conn.private.phoenix_action}"
  end

  defp template(template) do
    "template:#{template}"
  end

  defp channel(socket) do
    "channel:#{socket.channel}"
  end

  defp handler(socket) do
    "handler:#{socket.handler}"
  end

  defp event(event) do
    "event:#{event}"
  end
end
