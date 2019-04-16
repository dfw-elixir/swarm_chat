defmodule SwarmChat.MixProject do
  use Mix.Project

  def project do
    [
      app: :swarm_chat,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SwarmChat.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:swarm, "~> 3.0"},
      {:libcluster, "~> 3.0.3"}
    ]
  end
end
