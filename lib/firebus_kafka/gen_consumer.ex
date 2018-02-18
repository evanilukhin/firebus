defmodule FirebusKafka.GenConsumer do
  use KafkaEx.GenConsumer

  alias KafkaEx.Protocol.Fetch.Message

  require Logger

  # note - messages are delivered in batches
  def handle_message_set(message_set, state) do
    for %Message{value: message} <- message_set do
      FirebusWeb.Endpoint.broadcast("test_room:lobby", "new_msg", %{body: message})
    end
    {:async_commit, state}
  end
end
