defmodule MixProject do
  use Mix.Project

  def project do
    [
      app: :playground,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        flags: [
          :error_handling,
          :extra_return,
          :missing_return,
          :underspecs,
          :unmatched_returns,
          :unknown
        ]
      ],
      releases: [
        deploy: [
          include_executables_for: [:unix],
          applications: [playground: :permanent]
        ]
      ]
    ]
  end

  def application do
    [
      mod: {Playground.Application, []},
      extra_applications: [:logger, :inets]
    ]
  end

  defp aliases do
    [
      start: ["deps.get", "run --no-halt"]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:amqp_client, "~> 4.0"},
      {:bandit, "~> 1.6"},
      {:plug, "~> 1.16"}
    ]
  end
end
