defmodule Memory do
  use GenServer

  def init(pid) do
    {:ok, pid}
  end

  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  # Public API
  def start_link() do
    GenServer.start_link(Memory, [])
  end

  def push(pid, item) do
    GenServer.cast(pid, {:push, item})
  end

  def list(pid) do
    GenServer.call(pid, :list)
  end
end
