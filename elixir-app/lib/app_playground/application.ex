defmodule AppPlayground.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      :poolboy.child_spec(pool_name(), pool_config(), [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: :"#{__MODULE__}.Supervisor")
  end

  def run(fun) do
    try do
      :poolboy.transaction(pool_name(), fn task_fun_srv ->
        {:ok, AppPlayground.TaskFun.run(task_fun_srv, fun)}
      end)
    catch
      :exit, reason ->
        {:exit, reason}
    end
  end

  defp pool_config do
    [
      name: {:local, pool_name()},
      worker_module: AppPlayground.TaskFun,
      size: 5,
      max_overflow: 2
    ]
  end

  defp pool_name, do: :task_fun_worker
end
