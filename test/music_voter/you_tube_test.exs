defmodule MusicVoter.YouTubeTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  import Mox

  alias MusicVoter.YouTube
  alias MusicVoter.HTTPClientMock

  setup :verify_on_exit!

  @items [
    %{
      "id" => %{"kind" => "youtube#video", "videoId" => "LPTlvQ1Zet0"},
      "kind" => "youtube#searchResult",
      "snippet" => %{"title" => "Ric Flair Drip (Official Music Video)"}
    },
    %{
      "id" => %{"kind" => "youtube#video", "videoId" => "UkoUJZ-uR6Y"},
      "kind" => "youtube#searchResult",
      "snippet" => %{"title" => "Beautiful To Me (Audio)"}
    }
  ]

  describe "search/1" do
    test "returns the items from a successful response" do
      expect(HTTPClientMock, :get!, fn _url ->
        %{status_code: 200, body: Jason.encode!(%{"items" => @items})}
      end)

      assert YouTube.search("ric flair") == @items
    end

    test "returns an empty list when the API has no results" do
      expect(HTTPClientMock, :get!, fn _url ->
        %{status_code: 200, body: Jason.encode!(%{"items" => []})}
      end)

      assert YouTube.search("zzzzzzzz") == []
    end

    test "calls the YouTube v3 search endpoint with a URL-encoded query" do
      expect(HTTPClientMock, :get!, fn url ->
        assert url =~ "https://www.googleapis.com/youtube/v3/search?"
        assert url =~ "part=snippet"
        assert url =~ "maxResults=5"
        assert url =~ "type=video"
        assert url =~ "q=ric%20flair%20drip"
        %{status_code: 200, body: Jason.encode!(%{"items" => []})}
      end)

      YouTube.search("ric flair drip")
    end

    test "includes the API key from YOUTUBE_API_KEY" do
      original = System.get_env("YOUTUBE_API_KEY")
      System.put_env("YOUTUBE_API_KEY", "test-key-123")

      on_exit(fn ->
        if original,
          do: System.put_env("YOUTUBE_API_KEY", original),
          else: System.delete_env("YOUTUBE_API_KEY")
      end)

      expect(HTTPClientMock, :get!, fn url ->
        assert url =~ "key=test-key-123"
        %{status_code: 200, body: Jason.encode!(%{"items" => []})}
      end)

      YouTube.search("anything")
    end

    test "returns [] and logs an error when the API quota is reached (403)" do
      expect(HTTPClientMock, :get!, fn _url ->
        %{status_code: 403, body: Jason.encode!(%{"error" => %{"code" => 403}})}
      end)

      log =
        capture_log(fn ->
          assert YouTube.search("quota") == []
        end)

      assert log =~ "API quota reached"
    end

    test "raises when the response body is not valid JSON" do
      expect(HTTPClientMock, :get!, fn _url ->
        %{status_code: 200, body: "<html>not json</html>"}
      end)

      assert_raise Poison.ParseError, fn -> YouTube.search("bad body") end
    end

    test "propagates errors raised by the HTTP client" do
      expect(HTTPClientMock, :get!, fn _url ->
        raise HTTPoison.Error, reason: :timeout
      end)

      assert_raise HTTPoison.Error, fn -> YouTube.search("timeout") end
    end
  end
end
