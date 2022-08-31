defmodule AppPlayground.MixProject do
  use Mix.Project

  def project do
    [
      app: :app_playground,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {AppPlayground.Application, %{env: Mix.env()}},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [{:poolboy, "~> 1.5"}]
  end
end
