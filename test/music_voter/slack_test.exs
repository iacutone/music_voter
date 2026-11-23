defmodule MusicVoter.SlackTest do
  use ExUnit.Case, async: false

  import Mox

  alias MusicVoter.Slack
  alias MusicVoter.HTTPClientMock

  setup :verify_on_exit!

  setup do
    original = System.get_env("SLACK_WEBHOOK")
    System.put_env("SLACK_WEBHOOK", "https://hooks.slack.test/services/T/B/X")

    on_exit(fn ->
      if original,
        do: System.put_env("SLACK_WEBHOOK", original),
        else: System.delete_env("SLACK_WEBHOOK")
    end)
  end

  describe "post_to_slack/1" do
    test "posts the encoded message to the SLACK_WEBHOOK url" do
      expect(HTTPClientMock, :post, fn url, body ->
        assert url == "https://hooks.slack.test/services/T/B/X"
        assert body == ~s({"text":"hi"})
        {:ok, %{status_code: 200, body: "ok"}}
      end)

      assert {:ok, %{status_code: 200}} = Slack.post_to_slack(~s({"text":"hi"}))
    end
  end

  describe "send_msg/1" do
    test "encodes the message as a Slack webhook payload" do
      expect(HTTPClientMock, :post, fn _url, body ->
        assert Jason.decode!(body) == %{
                 "username" => "incoming-webhook",
                 "icon_emoji" => ":left-shark:",
                 "text" => "Eric added: Song"
               }

        {:ok, %{status_code: 200, body: "ok"}}
      end)

      assert {:ok, _} = Slack.send_msg("Eric added: Song")
    end

    test "returns the error tuple when the request fails" do
      expect(HTTPClientMock, :post, fn _url, _body ->
        {:error, %HTTPoison.Error{reason: :timeout}}
      end)

      assert {:error, %HTTPoison.Error{reason: :timeout}} = Slack.send_msg("hello")
    end
  end
end
