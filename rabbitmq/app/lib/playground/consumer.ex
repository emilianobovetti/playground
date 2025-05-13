defmodule Playground.Consumer do
  use GenServer

  import Playground.AMQP,
    only: [
      amqp_params_network: 1,
      basic_consume: 1,
      basic_consume_ok: 1,
      basic_deliver: 1,
      basic_publish: 1,
      basic_ack: 1,
      amqp_msg: 1,
      p_basic: 1
    ]

  require Logger

  defmodule State do
    @enforce_keys [
      :consumer_tag,
      :connection,
      :channel
    ]

    defstruct @enforce_keys
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl GenServer
  def init(_opts) do
    # ref: https://www.rabbitmq.com/client-libraries/erlang-client-user-guide#connecting
    {:ok, connection} =
      [
        username: "guest",
        password: "guest",
        virtual_host: "domain-a",
        host: ~c"rabbitmq-2"
      ]
      |> amqp_params_network()
      |> :amqp_connection.start()

    {:ok, channel} = :amqp_connection.open_channel(connection)

    basic_consume_ok(consumer_tag: consumer_tag) =
      :amqp_channel.subscribe(
        channel,
        basic_consume(queue: "domain-a.gutexberg-input"),
        self()
      )

    {:ok,
     %State{
       consumer_tag: consumer_tag,
       connection: connection,
       channel: channel
     }}
  end

  @impl GenServer
  def handle_info({basic_deliver(delivery_tag: tag, routing_key: key), msg}, %State{} = state) do
    # for reasons I need to explore if I just publish the `msg` as it is
    # the federated exchanges don't receive this message
    amqp_msg(props: props, payload: payload) = msg
    p_basic(headers: headers) = props

    delivery_count =
      Enum.find_value(headers, fn
        {"x-delivery-count", :long, dc} -> dc
        _ -> nil
      end)

    if not is_nil(delivery_count) and delivery_count > 1 do
      Logger.warn("delivery_count = #{delivery_count}")
    end

    :ok =
      :amqp_channel.call(
        state.channel,
        basic_publish(
          exchange: "domain-a.gutexberg-output",
          routing_key: key
        ),
        amqp_msg(payload: payload)
      )

    :ok = :amqp_channel.call(state.channel, basic_ack(delivery_tag: tag))

    {:noreply, state}
  end

  def handle_info(basic_consume_ok([]), %State{} = state) do
    {:noreply, state}
  end

  def handle_info(info, %State{} = state) do
    Logger.error("unknown message in handle_info: #{inspect(info)}")

    {:noreply, state}
  end
end
