defmodule FirebusKafka.GenConsumer do
  use KafkaEx.GenConsumer

  alias KafkaEx.Protocol.Fetch.Message

  require Logger
  require IEx

  # note - messages are delivered in batches
  def handle_message_set(message_set, state) do
    for %Message{value: message} <- message_set do
      transformed_message = transform_message(message)
      FirebusWeb.Endpoint.broadcast("test_room:lobby", "new_msg", transformed_message)
      HTTPoison.post("http://0.0.0.0:8080", Poison.encode!(transformed_message), [{"Content-Type", "application/json"}])
    end
    {:async_commit, state}
  end

  def transform_message(message) do
    Poison.decode!(message)
    |> Map.put("firebus", DateTime.utc_now |> Time.to_string)
  end
end
