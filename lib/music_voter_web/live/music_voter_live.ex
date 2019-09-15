defmodule MusicVoterWeb.MusicVoterLive do
  require Logger
  use Phoenix.LiveView
  alias MusicVoterWeb.MusicVoterView
  alias MusicVoterWeb.Presence

  def render(assigns) do
    MusicVoterView.render("index.html", assigns)
  end

  def mount(session, socket) do
    MusicVoterWeb.Endpoint.subscribe("room:")
    MusicVoter.SongList.subscribe()
    songs = MusicVoter.SongList.songs(MusicVoter.SongList)
    Presence.track(self(), 
      "room:", 
      "1", 
      %{
        name: session.user.name,
        online_at: inspect(System.system_time(:second))
      }
    )

    {:ok, assign(socket, songs: songs, search: [], user: session.user, auth_token: session.auth_token, users: [])}
  end

  def handle_event("inc", id, socket) do
    {int, _string} = Integer.parse(id)
    MusicVoter.SongList.increment_score(MusicVoter.SongList, int, socket)

    songs = MusicVoter.SongList.songs(MusicVoter.SongList)
    {:noreply, assign(socket, songs: songs)}
  end

  def handle_event("add", %{"song" => %{"vid" => vid, "title" => title}}, socket) do
    song = MusicVoter.Song.new(vid, title)
    MusicVoter.SongList.add(MusicVoter.SongList, song)

    {:noreply, assign(socket, search: [])}
  end

  def handle_event("search", %{"search" => %{"query" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    {:noreply, assign(socket, search: MusicVoter.YouTube.search(query))}
  end

  def handle_event("comment", %{"song" => %{"id" => id, "comment" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("comment", %{"song" => %{"id" => id, "comment" => comment}}, socket) do
    comment = MusicVoter.Comment.new(socket.assigns.user.name, comment)
    {int, _string} = Integer.parse(id)
    MusicVoter.SongList.add_comment(MusicVoter.SongList, int, comment, socket)
    songs = MusicVoter.SongList.songs(MusicVoter.SongList)

    {:noreply, assign(socket, songs: songs)}
  end

  def handle_info({MusicVoter.SongList}, socket) do
    {:noreply, fetch_videos(socket)}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    users =   
      Presence.list("room:")
      |> Enum.map(fn {_id, x} -> 
        x[:metas] end) 
        |> List.flatten

    {:noreply, assign(socket, users: users)}
  end

  defp fetch_videos(socket) do
    songs = MusicVoter.SongList.songs(MusicVoter.SongList)
    Logger.info(inspect(songs))
    assign(socket, songs: songs)
  end

end
