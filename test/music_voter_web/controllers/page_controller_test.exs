defmodule MusicVoterWeb.PageControllerTest do
  use MusicVoterWeb.ConnCase

  describe "GET /" do
    test "redirects to the login page when there is no user in the session", %{conn: conn} do
      conn = get(conn, "/")

      assert redirected_to(conn) == "/sessions/new"
    end

    test "renders the app for a logged-in user", %{conn: conn} do
      conn =
        conn
        |> Plug.Test.init_test_session(%{current_user: MusicVoter.User.new("Eric")})
        |> get("/")

      assert html_response(conn, 200) =~ "Music Voter"
    end
  end
end
