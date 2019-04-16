# SwarmChat

> Example Bitwalker Swarm app for DFW Elixir Hack Night 2019.04.16

This demo runs a chat server. The chat worker is a global process running
on a single node in the cluster, but can be called by any of the other nodes.

Swarm is configured using the Gossip strategy, so all nodes on the same network
should automatically connect. Other strategies are [available
here](https://github.com/bitwalker/libcluster/tree/master/lib/strategy).

## Getting Started

Run each command in a separate shell:

```elixir
iex --sname n1 --cookie testing -S mix
```

```elixir
iex --sname n2 --cookie testing -S mix
```

In both shells, join the server as a different name:

```elixir
iex> SwarmChat.join "yourname"
```

Send messages back and forth.

```elixir
iex> SwarmChat.msg "this is a message"
```

When you are done, leave the server:

```elixir
iex> SwarmChat.leave
```

## Useful Debugging Commands

- `SwarmChat.whereis` gives current pid of the worker
- `SwarmChat.state` returns worker's state

## Ideas for Hacking on This Project

- Fix the memory leak in `SwarmChat.Worker` where dead pids are not cleaned up.
- Handle state recovery if the node with the worker crashes. Currently the
  worker's state is reset.
- Put the worker under a supervision tree (difficult with Swarm)

