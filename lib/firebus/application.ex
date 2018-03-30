defmodule Firebus.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    consumer_group_opts = [
      # setting for the ConsumerGroup
      heartbeat_interval: 1_000,
      # this setting will be forwarded to the GenConsumer
      commit_interval: 1_000
    ]

    gen_consumer_impl = FirebusKafka.GenConsumer
    consumer_group_name = "firebus_group"

    # Bad developer( (temporary hardcode)
    topic_names = ["virgin_messages"]

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      # supervisor(Firebus.Repo, []),
      # Start the endpoint when the application starts
      supervisor(FirebusWeb.Endpoint, []),
      supervisor(
        KafkaEx.ConsumerGroup,
        [gen_consumer_impl, consumer_group_name, topic_names, consumer_group_opts]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Firebus.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FirebusWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
