defmodule MusicVoterWeb.SessionController do
  use MusicVoterWeb, :controller

  def new(conn, _) do
    render(conn, "new.html", conn: conn)
  end

  def create(conn, %{"user" => %{"name" => name}}) do
    user = MusicVoter.User.new(name)

    conn
    |> put_session(:current_user, user)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
