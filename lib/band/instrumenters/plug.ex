if Code.ensure_loaded?(Plug) do
  defmodule Band.Instrumenters.Plug do
    @moduledoc """
    Instruments Plug connections to report each response to a client,
    with the request_method, request_path, and response_status as tags

    Usage:

        plug Band.Instrumenters.Plug

    """

    alias Band.Stats
    alias Plug.Conn
    @behaviour Plug

    def init(_opts), do: nil


    def call(conn, _) do

      start = System.monotonic_time()

      Conn.register_before_send(conn, fn conn ->
        stop = System.monotonic_time()
        time_diff = Stats.microseconds(stop - start)

        tags = [request_method(conn), request_path(conn), response_status(conn)]

        Band.histogram("plug.response", time_diff, tags: tags)

        conn
      end)
    end

    defp request_method(conn) do
      "request_method:#{conn.method}"
    end

    defp request_path(conn) do
      "request_path:#{conn.request_path}"
    end

    defp response_status(conn) do
      "response_status:#{Integer.to_string(conn.status)}"
    end

  end
end
