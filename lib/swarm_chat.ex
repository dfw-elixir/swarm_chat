defmodule SwarmChat do
  @moduledoc """
  Documentation for SwarmChat.
  """

  defstruct [:pid, :name]

  alias SwarmChat.Printer

  @mod SwarmChat.Worker

  def join(name) do
    case Process.get(:name) do
      nil ->
        pid = Printer.new()
        GenServer.call({:via, :swarm, @mod}, {:join, pid})

        Process.put(:name, name)
        Process.put(:printer, pid)

        GenServer.call({:via, :swarm, @mod}, {:msg, "#{name} joined."})

      name ->
        IO.puts("Already joined as #{name}.")
    end
  end

  def whereis, do: Swarm.whereis_name(SwarmChat.Worker)

  def state, do: SwarmChat.Worker |> Swarm.whereis_name() |> :sys.get_state()

  def leave do
    case Process.get(:name) do
      nil ->
        :ok

      name ->
        pid = Process.get(:printer)

        GenServer.call({:via, :swarm, @mod}, {:msg, "#{name} left."})
        GenServer.call({:via, :swarm, @mod}, {:leave, pid})

        Process.exit(pid, :kill)
        Process.delete(:name)
        Process.delete(:printer)
        :ok
    end
  end

  def msg(msg) do
    msg = if is_binary(msg), do: msg, else: inspect(msg)

    case Process.get(:name) do
      nil -> IO.puts("You must join first.")
      name -> GenServer.call({:via, :swarm, @mod}, {:msg, "[#{name}] #{msg}"})
    end
  end
end
