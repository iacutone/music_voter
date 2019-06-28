defmodule MusicVoterWeb.MusicVoterLive do
  use Phoenix.LiveView
  alias MusicVoterWeb.MusicVoterView

  def render(assigns) do
    MusicVoterView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, fetch_videos(socket)}
  end

  def handle_event("inc", id, socket) do
    {int, string} = Integer.parse(id)
    MusicVoter.SongList.increment_score(MusicVoter.SongList, int)
    {:noreply, fetch_videos(socket)}
  end

  def handle_event("dec", id, socket) do
    {int, string} = Integer.parse(id)
    MusicVoter.SongList.decrement_score(MusicVoter.SongList, int)
    {:noreply, fetch_videos(socket)}
  end

  def handle_event("add", %{"song" => song}, socket) do
    MusicVoter.SongList.add(MusicVoter.SongList, MusicVoter.Song.new(song["url"]))

    {:noreply, fetch_videos(socket)}
  end

  defp fetch_videos(socket) do
    assign(socket, songs: MusicVoter.SongList.view(MusicVoter.SongList))
  end
end
