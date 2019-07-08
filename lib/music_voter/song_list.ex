defmodule MusicVoter.SongList do
  use GenServer

  @topic inspect(__MODULE__)

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
    songs = GenServer.call(pid, :view)
    songs = Enum.sort_by songs, & &1.score
    songs = Enum.filter(songs, fn song -> song.title != nil end)
    Enum.reverse(songs)
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


    broadcast_change()
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


    broadcast_change()
    {:noreply, updated_list}
  end

  def handle_cast(song, list) do
    updated_list = [song | list]
    broadcast_change()
    {:noreply, updated_list}
  end

  def handle_call(:view, _from, list) do
    {:reply, list, list}
  end

  def init(list) do
    IO.puts "GEN SERVER started"
    {:ok, list}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(MusicVoter.PubSub, @topic)
  end

  defp broadcast_change do
    Phoenix.PubSub.broadcast(MusicVoter.PubSub, @topic, {__MODULE__})

    :ok
  end
end
