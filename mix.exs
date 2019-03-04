defmodule Mcrypto.MixProject do
  use Mix.Project

  @top Path.join(File.cwd!(), ".")
  @version @top |> Path.join("version") |> File.read!() |> String.trim()
  @elixir_version @top |> Path.join(".elixir_version") |> File.read!() |> String.trim()

  def project do
    [
      app: :mcrypto,
      version: @version,
      elixir: @elixir_version,
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [ignore_warnings: ".dialyzer_ignore.exs", plt_add_apps: []],
      description: description(),
      package: package(),
      # Docs
      name: "Mcrypto",
      source_url: "https://github.com/arcblock/mcrypto",
      homepage_url: "https://github.com/arcblock/mcrypto",
      docs: [
        main: "Mcrypto",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(env) when env in [:dev, :test, :integration], do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:keccakf1600, "~> 2.0", hex: :keccakf1600_orig},
      {:libdecaf, "~> 1.0"},
      {:libsecp256k1, "~> 0.1.3"},
      {:typed_struct, "~> 0.1.4"},
      {:blake2, "~> 1.0"},

      # dev and test
      {:credo, "~> 1.0.0", only: [:dev, :test]},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.19.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:test]},
      {:pre_commit_hook, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Multiple crypto support.
    """
  end

  defp package do
    [
      files: [
        "config",
        "lib",
        "mix.exs",
        "README*",
        "version",
        ".elixir_version"
      ],
      licenses: ["Apache 2.0"],
      maintainers: ["tyr.chen@gmail.com"],
      links: %{
        "GitHub" => "https://github.com/arcblock/mcrypto",
        "Docs" => "https://hexdocs.pm/mcrypto"
      }
    ]
  end
end
