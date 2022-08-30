defmodule MusicVoterWeb.MusicVoterLive do
  use MusicVoterWeb, :live_view

  alias MusicVoterWeb.MusicVoterView
  alias MusicVoterWeb.Presence

  def render(assigns) do
    MusicVoterView.render("index.html", assigns)
  end

    def mount(_params, session, socket) do
    MusicVoterWeb.Endpoint.subscribe("room:")
    MusicVoter.SongList.subscribe()
    songs = MusicVoter.SongList.songs(MusicVoter.SongList)
    Presence.track(self(), 
      "room:", 
      "1", 
      %{
        name: Map.get(session, "user").name,
        online_at: inspect(System.system_time(:second))
      }
    )

    {:ok, assign(socket, 
      songs: songs, 
      search: [], 
      user: Map.get(session, "user"), 
      auth_token: Map.get(session, "auth_token"), 
      users: [], 
      song_playing_vid: nil)
    }
  end

  def handle_event("play", _, socket) do
    vid = MusicVoter.SongTracker.play(MusicVoter.SongTracker, socket)
    {:noreply, assign(socket, song_playing_vid: vid)}
  end

  def handle_event("stop", _, socket) do
    {:noreply, assign(socket, song_playing_vid: nil)}
  end

  def handle_event("next", _, socket) do
    vid = socket.assigns.song_playing_vid
    vid = MusicVoter.SongTracker.next(MusicVoter.SongTracker, socket, vid)
    {:noreply, assign(socket, song_playing_vid: vid)}
  end

  def handle_event("previous", _, socket) do
    vid = socket.assigns.song_playing_vid
    vid = MusicVoter.SongTracker.previous(MusicVoter.SongTracker, socket, vid)
    {:noreply, assign(socket, song_playing_vid: vid)}
  end

  def handle_event("inc", %{"song" => id}, socket) do
    {int, _string} = Integer.parse(id)
    MusicVoter.SongList.increment_score(MusicVoter.SongList, int, socket)

    songs = MusicVoter.SongList.songs(MusicVoter.SongList)
    {:noreply, assign(socket, songs: songs)}
  end

  def handle_event("add", %{"song" => %{"vid" => vid, "title" => title}}, socket) do
    song = MusicVoter.Song.new(vid, title)
    MusicVoter.SongList.add_song(MusicVoter.SongList, song, socket)

    {:noreply, assign(socket, search: [])}
  end

  def handle_event("search", %{"search" => %{"query" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    {:noreply, assign(socket, search: MusicVoter.YouTube.search(query))}
  end

  def handle_event("comment", %{"song" => %{"id" => _id, "comment" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("comment", %{"song" => %{"id" => id, "comment" => comment}}, socket) do
    comment = MusicVoter.Comment.new(socket.assigns.user.name, comment)
    {int, _string} = Integer.parse(id)
    MusicVoter.SongList.add_comment(MusicVoter.SongList, int, comment, socket)
    songs = MusicVoter.SongList.songs(MusicVoter.SongList)

    {:noreply, assign(socket, songs: songs)}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    users =   
      Presence.list("room:")
      |> Enum.map(fn {_id, x} -> 
        x[:metas] end) 
        |> List.flatten

    {:noreply, assign(socket, users: users)}
  end

  def handle_info({MusicVoter.SongList}, socket) do
    {:noreply, fetch_videos(socket)}
  end

  defp fetch_videos(socket) do
    songs = MusicVoter.SongList.songs(MusicVoter.SongList)
    assign(socket, songs: songs)
  end
end
