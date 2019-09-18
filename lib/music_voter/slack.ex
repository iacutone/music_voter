defmodule MusicVoter.Slack do
  def post_to_slack(encoded_msg) do
    url = System.get_env("SLACK_WEBHOOK")

    HTTPoison.post(
      url,
      encoded_msg
    )
  end

  def send_msg(msg) do
    Poison.encode!(%{
      "username" => "incoming-webhook",
      "icon_emoji" => ":left-shark:",
      "text" => msg
    })
    |> post_to_slack
  end
end
