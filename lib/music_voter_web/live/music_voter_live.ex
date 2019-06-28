defmodule MusicVoterWeb.MusicVoterLive do
  use Phoenix.LiveView
  alias MusicVoterWeb.MusicVoterView

  def render(assigns) do
    MusicVoterView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, fetch_videos(socket)}
  end

  def handle_event("inc", _value, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _value, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("add", %{"song" => song}, socket) do
    MusicVoter.SongList.add(MusicVoter.SongList, %MusicVoter.Song{url: song["url"], score: 1})

    {:noreply, fetch_videos(socket)}
  end

  defp fetch_videos(socket) do
    assign(socket, songs: MusicVoter.SongList.view(MusicVoter.SongList))
  end
end
