defmodule MusicVoterWeb.PageController do
  use MusicVoterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
