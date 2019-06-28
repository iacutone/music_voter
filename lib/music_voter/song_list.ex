defmodule MusicVoter.SongList do
  use GenServer

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add(pid, song) do
    GenServer.cast(pid, song)
  end

  def view(pid) do
    GenServer.call(pid, :view)
  end

  def remove(pid, song) do
    GenServer.cast(pid, {:remove, song})
  end

  def stop(pid) do
    GenServer.stop(pid, :normal, :infinity) # default values
  end

  # Server
  def terminate(_reason, list) do
    IO.puts("Song removed")
    IO.inspect(list)
    :ok
  end

  def handle_cast({:remove, song}, list) do
    updated_list = Enum.reject(list, fn(item) -> item == song end)
    {:noreply, updated_list}
  end

  def handle_cast(song, list) do
    updated_list = [song|list]
    {:noreply, updated_list}
  end

  def handle_call(:view, _from, list) do
    {:reply, list, list}
  end

  def init(list) do
    IO.puts "GEN SERVER started"
    {:ok, list}
  end
end
