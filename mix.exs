defmodule Band.Mixfile do
  use Mix.Project

  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: :band,
      version: @version,
      build_path: "_build",
      config_path: "config/config.exs",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: doc(),
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:statix, "~> 1.1"},
      {:absinthe, "~> 1.3", optional: true},
      {:phoenix, "~> 1.3", optional: true},
      {:fuse, "~> 2.4", optional: true},
      {:plug, "~> 1.5", optional: true},
      {:ex_doc, "~> 0.18", only: :dev},
    ]
  end

  defp doc do
    [extras: ["README.md"], main: "readme"]
  end

  defp description do
    """
    A collection of instrumenters for common elixir projects.
    """
  end

  defp package do
    [
      maintainers: ["Chris Keathley", "Greg Mefford", "Jeff Weiss", "Sonny Scroggin", "Jeff Gran"],
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/letoteteam/band"}
    ]
  end

  defp package_files do
    [
      "lib",
      "mix.exs",
      "README.md",
      "VERSION",
      "LICENSE",
    ]
  end
end
