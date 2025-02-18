defmodule Playground.Producer do
  use GenServer

  import Playground.AMQP, only: [amqp_params_network: 1, basic_publish: 1, amqp_msg: 1]

  defmodule State do
    @enforce_keys [:connection, :channel, :timer_ref]

    defstruct @enforce_keys
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl GenServer
  def init(_opts) do
    # ref: https://www.rabbitmq.com/client-libraries/erlang-client-user-guide#connecting
    {:ok, conn} =
      [
        username: "guest",
        password: "guest",
        virtual_host: "domain-x",
        host: ~c"rabbitmq-1"
      ]
      |> amqp_params_network()
      |> :amqp_connection.start()

    {:ok, chan} = :amqp_connection.open_channel(conn)

    {:ok,
     %State{
       connection: conn,
       channel: chan,
       timer_ref: schedule_produce()
     }}
  end

  @impl GenServer
  def handle_info(:produce, %State{} = state) do
    # note: :amqp_channel.cast has the same interface
    :ok =
      :amqp_channel.call(
        state.channel,
        basic_publish(
          exchange: "gutexberg-input-1",
          routing_key: "com.helloprima.msg1"
        ),
        amqp_msg(payload: :rand.bytes(16) |> Base.encode16())
      )

    {:noreply, %State{state | timer_ref: schedule_produce()}}
  end

  defp schedule_produce do
    Process.send_after(self(), :produce, 100)
  end
end
