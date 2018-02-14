defmodule BandTest do
  use ExUnit.Case
  doctest Band

  test "application env config" do
    Application.put_env(:band, :prefix, "default")
    Application.put_env(:band, :host, "localhost")
    Application.put_env(:band, :port, 8125)

    Band.start_link([])

    statix = Application.get_all_env(:statix)
    assert statix[:prefix] == "default"
    assert statix[:host] == "localhost"
    assert statix[:port] == 8125
  end

  test "runtime config overrides application env" do
    Application.put_env(:band, :prefix, "default")
    Application.put_env(:band, :host, "statsd")
    Application.put_env(:band, :port, 8125)

    Band.start_link([prefix: "changed", host: "localhost", port: 1234])

    statix = Application.get_all_env(:statix)

    assert statix[:prefix] == "changed"
    assert statix[:host] == "localhost"
    assert statix[:port] == 1234
  end

  test "child_spec/1" do
    assert Band.child_spec([]) == %{
      id: Band,
      start: {Band, :start_link, [[]]},
      restart: :temporary,
      type: :worker,
      shutdown: 5000
    }
  end
end
