defmodule Mcrypto.MixProject do
  use Mix.Project
  @top Path.join(File.cwd!(), ".")

  @version @top |> Path.join("version") |> File.read!() |> String.trim()
  @elixir_version @top
                  |> Path.join(".elixir_version")
                  |> File.read!()
                  |> String.trim()
  def project do
    [
      app: :mcrypto,
      version: @version,
      elixir: @elixir_version,
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [ignore_warnings: ".dialyzer_ignore.exs", plt_add_apps: []]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:integration), do: elixirc_paths(:test)
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:keccakf1600, "~> 2.0", hex: :keccakf1600_orig},
      {:libdecaf, "~> 1.0"},
      {:libsecp256k1, "~> 0.1.3"},
      {:typed_struct, "~> 0.1.4"},

      # dev and test
      {:credo, "~> 1.0.0", only: [:dev, :test]},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.19.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:test]},
      {:pre_commit_hook, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end
end
