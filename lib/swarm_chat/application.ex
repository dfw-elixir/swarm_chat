defmodule SwarmChat.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      cluster_supervisor()
    ]

    Swarm.whereis_or_register_name(SwarmChat.Worker, SwarmChat.Worker, :start_link, [])

    opts = [strategy: :one_for_one, name: SwarmChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cluster_supervisor do
    topologies = [
      cluster: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]

    {Cluster.Supervisor, [topologies, [name: SwarmChat.ClusterSupervisor]]}
  end
end
