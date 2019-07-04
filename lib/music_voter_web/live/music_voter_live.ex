defmodule MusicVoterWeb.MusicVoterLive do
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

  def handle_event("dec", id, socket) do
    {int, _string} = Integer.parse(id)
    MusicVoter.SongList.decrement_score(MusicVoter.SongList, int)
    {:noreply, fetch_videos(socket)}
  end

  def handle_event("add", %{"song" => song}, socket) do
    song = MusicVoter.SongList, MusicVoter.Song.new(song["url"])
    if song do
      MusicVoter.SongList.add(song)
    end

    {:noreply, fetch_videos(socket)}
  end

  def handle_info({MusicVoter.SongList}, socket) do
    {:noreply, fetch_videos(socket)}
  end

  defp fetch_videos(socket) do
    assign(socket, songs: MusicVoter.SongList.view(MusicVoter.SongList))
  end
end
