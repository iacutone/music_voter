defmodule MusicVoterWeb.PageController do
  use MusicVoterWeb, :controller

  plug :require_user

  def index(conn, _params) do
    render(conn, "index.html", user: get_session(conn, :current_user))
  end

  defp require_user(conn, _opts) do
    if get_session(conn, :current_user) do
      conn
        |> assign(:auth_token, generate_auth_token(conn))
    else
      conn
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  defp generate_auth_token(conn) do
    current_player = get_session(conn, :current_user)
    Phoenix.Token.sign(conn, "player auth", current_player)
  end
end
