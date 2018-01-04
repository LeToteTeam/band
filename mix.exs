defmodule Metrix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :metrix,
      version: "0.1.0",
      build_path: "_build",
      config_path: "config/config.exs",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Metrix.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:statix, "~> 1.1"},
      {:absinthe, "~> 1.3", optional: true},
      {:phoenix, "~> 1.3", optional: true},
      {:fuse, "~> 2.4.0", optional: true},
    ]
  end
end
