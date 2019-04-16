defmodule SwarmChat.Worker do
  @moduledoc false
  defstruct pids: MapSet.new()

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:ok, %__MODULE__{}}
  end

  def handle_call({:join, pid}, _from, state) do
    pids = MapSet.put(state.pids, pid)
    {:reply, :ok, %{state | pids: pids}}
  end

  def handle_call({:leave, pid}, _from, state) do
    pids = MapSet.delete(state.pids, pid)
    {:reply, :ok, %{state | pids: pids}}
  end

  def handle_call({:msg, msg}, {_ref, from}, state) do
    for pid <- state.pids do
      spawn(fn -> send(pid, {from, msg}) end)
    end

    {:reply, :ok, state}
  end

  def handle_call({:swarm, :begin_handoff}, _from, state) do
    {:reply, {:resume, state}, state}
  end

  def handle_cast({:swarm, :end_handoff, old_state}, new_state) do
    pids = MapSet.union(old_state.pids, new_state.pids)
    {:noreply, %__MODULE__{pids: pids}}
  end

  def handle_cast({:swarm, :resolve_conflict, _delay}, state) do
    {:noreply, state}
  end

  def handle_info({:swarm, :die}, state) do
    {:stop, :shutdown, state}
  end
end
