defmodule SwarmChat.Printer do
  def new do
    spawn(fn -> recv_loop() end)
  end

  defp recv_loop do
    pid = self()

    receive do
      {^pid, _msg} -> nil
      {_pid, msg} when is_binary(msg) -> IO.puts(msg)
      {_pid, msg} -> IO.inspect(msg)
    end

    recv_loop()
  end
end
