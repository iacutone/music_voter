defmodule MusicVoter.SongTracker do
  use GenServer

  # Client

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def play(pid, socket) do
    GenServer.call(pid, {:play, socket})
  end

  def next(pid, socket, vid) do
    GenServer.call(pid, {:next, socket, vid})
  end

  def previous(pid, socket, vid) do
    GenServer.call(pid, {:previous, socket, vid})
  end

  # Server

  def handle_call({:play, socket}, _from, state) do
    songs = MusicVoter.SongList.songs(MusicVoter.SongList)
    song_vid = Enum.at(songs, 0).vid
    
    {:reply, song_vid, state}
  end

  def handle_call({:next, socket, vid}, _from, state) do
    {song_positions, song_map, songs} = tracker(vid)

    song_vid = if Enum.count(songs) == song_positions[vid] + 1 do
      song_map[0]
    else
      song_map[song_positions[vid] + 1]
    end

    {:reply, song_vid, state}
  end

  def handle_call({:previous, socket, vid}, _from, state) do
    {song_positions, song_map, songs} = tracker(vid)

    song_vid = if song_positions[vid] == 0 do
      song_map[Enum.count(songs) - 1]
    else
      song_map[song_positions[vid] - 1]
    end

    {:reply, song_vid, state}
  end

  def init(_) do
    IO.puts "GEN SERVER started, horrrray"
    {:ok, ""}
  end

  defp tracker(vid) do
    songs = MusicVoter.SongList.songs(MusicVoter.SongList)

    song_positions = Enum.reduce(songs, %{}, fn song, acc ->
      Map.put(acc, song.vid, Enum.count(acc))
    end)

    song_map = Enum.reduce(songs, %{}, fn song, acc ->
      Map.put(acc, Enum.count(acc), song.vid)
    end)

    {song_positions, song_map, songs}
  end
end
