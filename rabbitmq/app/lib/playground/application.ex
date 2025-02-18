defmodule Playground.Application do
  use Application

  @dialyzer {:no_underspecs, {:children, 1}}
  @dialyzer {:no_match, {:children, 1}}

  @env Mix.env()

  @impl Application
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Playground.Supervisor]

    Supervisor.start_link(children(@env), opts)
  end

  @spec children(atom) :: [Supervisor.child_spec() | {module, any} | module]
  defp children(:dev) do
    [Playground.CodeWatcher | children(:prod)]
  end

  defp children(_env) do
    [
      {Bandit, plug: PlaygroundWeb.Router, scheme: :http, ip: {0, 0, 0, 0}, port: 80}
      | Application.fetch_env!(:playground, :mode) |> children_for()
    ]
  end

  defp children_for("producer") do
    [Playground.Producer]
  end

  defp children_for("consumer") do
    [Playground.Consumer]
  end

  defp children_for(mode), do: raise(ArgumentError, "unkown mode #{mode}")
end
