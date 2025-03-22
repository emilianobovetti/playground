defmodule Playground.CodeWatcher do
  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl GenServer
  def init(_opts) do
    inotifywait =
      with false <- :os.find_executable(~c"inotifywait") do
        raise "Could not find inotifywait executable"
      end

    port =
      Port.open({:spawn_executable, inotifywait}, [
        :binary,
        :stderr_to_stdout,
        args: [
          "--monitor",
          "--recursive",
          "--exclude",
          "\\.elixir_ls|\\.lexical|_build|\\.git",
          "--event",
          "close_write",
          "--event",
          "move",
          "--event",
          "delete",
          "."
        ]
      ])

    {:ok, port}
  end

  @impl GenServer
  def handle_info({port, {:data, <<"Setting up watches", _::binary>>}}, port) do
    {:noreply, port}
  end

  def handle_info({port, {:data, <<"Watches established", _::binary>>}}, port) do
    {:noreply, port}
  end

  def handle_info({port, {:data, event}}, port) do
    Logger.info(event)

    # Stolen from https://github.com/phoenixframework/phoenix/blob/7b5cd358aadb507cd90aa3a52e013f9e9e947ac4/lib/phoenix/code_reloader/server.ex#L73-L82
    {:module, Mix.Task} = Code.ensure_loaded(Mix.Task)

    config = Mix.Project.config()

    for compiler <- Mix.compilers() do
      Mix.Task.reenable("compile.#{compiler}")

      compile_args = [
        "--purge-consolidation-path-if-stale",
        Mix.Project.consolidation_path(config)
      ]

      {_status, _diagnostics} = Mix.Task.run("compile.#{compiler}", compile_args)
    end

    Mix.Task.reenable("compile.protocols")
    Mix.Task.run("compile.protocols")

    {:noreply, port}
  end
end
