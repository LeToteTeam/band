# Band

> A collection of instruments

Band is a collection of instumentation helpers to aid in publishing metrics via
`statsd`.

## Configuration

Band can be configured statically or at runtime in order to be flexible for many
different deployment strategies.

If you wish to use `Mix` config, you can add the following to your `config.exs`:

```ex
config :band,
  prefix: "my-app",
  host: "localhost",
  port: 8125
```

Then add the `Band` worker to your application's supervision tree:

```ex
children = [
  ...
  worker(Band, [[]])
]
```

Band also supports `child_spec/1`:

```ex
children = [
  ...
  {Band, []}
]
```

If you need to configure Band at runtime, you can simply pass in the options
directly into the child options:

```ex
band_config = [
  prefix: "my-app",
  host: System.get_env("BAND_HOST"),
  port: String.to_integer(System.get_env("BAND_PORT"))
]

children = [
  ...
  {Band, band_config}
]
```

Any options specified in the `Mix` config will be merged in as well.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs
can be found at [https://hexdocs.pm/band](https://hexdocs.pm/band).
