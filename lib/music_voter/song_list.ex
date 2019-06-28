defmodule MusicVoter.SongList do
  use GenServer

  # Client

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def increment_score(pid, id) do
    GenServer.cast(pid, {:increment_score, id})
  end

  def decrement_score(pid, id) do
    GenServer.cast(pid, {:decrement_score, id})
  end

  def add(pid, song) do
    GenServer.cast(pid, song)
  end

  def view(pid) do
    GenServer.call(pid, :view)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal, :infinity) # default values
  end

  # Server

  def handle_cast({:increment_score, id}, songs) do
    updated_list = Enum.map(songs, fn song ->
      if song.id == id do
        %MusicVoter.Song{song | score: song.score + 1}
      else
        song
      end
    end)


    {:noreply, updated_list}
  end

  def handle_cast({:decrement_score, id}, songs) do
    updated_list = Enum.map(songs, fn song ->
      if song.id == id do
        %MusicVoter.Song{song | score: song.score - 1}
      else
        song
      end
    end)


    {:noreply, updated_list}
  end

  def handle_cast(song, list) do
    updated_list = [song | list]
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
