defmodule MusicVoterWeb.MusicVoterLive do
  require Logger
  use Phoenix.LiveView
  alias MusicVoterWeb.MusicVoterView

  def render(assigns) do
    MusicVoterView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    MusicVoter.SongList.subscribe()

    {:ok, fetch_videos(socket)}
  end

  def handle_event("inc", id, socket) do
    {int, _string} = Integer.parse(id)
    MusicVoter.SongList.increment_score(MusicVoter.SongList, int)
    {:noreply, fetch_videos(socket)}
  end

  def handle_event("add", %{"song" => song}, socket) do
    song = MusicVoter.Song.new(song["url"])
    if song do
      MusicVoter.SongList.add(MusicVoter.SongList, song)
    end

    {:noreply, fetch_videos(socket)}
  end

  def handle_info({MusicVoter.SongList}, socket) do
    {:noreply, fetch_videos(socket)}
  end

  defp fetch_videos(socket) do
    songs = MusicVoter.SongList.view(MusicVoter.SongList)
    Logger.info(inspect(songs))
    assign(socket, songs: songs)
  end
end
