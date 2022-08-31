defmodule AppPlayground.TaskFun do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def run(srv, fun) when is_function(fun, 0) do
    GenServer.call(srv, {:run, fun})
  end

  @impl GenServer
  def init(_opts) do
    {:ok, nil}
  end

  @impl GenServer
  def handle_call({:run, fun}, _from, state) when is_function(fun, 0) do
    {:reply, fun.(), state}
  end
end
