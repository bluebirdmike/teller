defmodule TellerApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :teller_api,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug, :poison],
      mod: {TellerApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.5"},
      {:plug_cowboy, "~> 1.0"},
      {:poison, "~> 3.1"}
    ]
  end
end
