defmodule MusicVoter.YouTube do
  def title(url) do
    id = id(url)
    key = System.get_env("YOUTUBE_API_KEY")
    youtube_v3_url = "https://www.googleapis.com/youtube/v3/"
    id = "id=" <> id
    video = "#{youtube_v3_url}videos?part=snippet&#{id}&key=#{key}"

    %{body: body} = HTTPoison.get!(video)
    decoded = Poison.decode!(body)
    List.first(decoded["items"])["snippet"]["title"]
  end

  defp id(url) do
    split_url = Regex.split(~r/(vi\/|v%3D|v=|\/v\/|youtu\.be\/|\/embed\/)/, url)

    case Enum.count(split_url) do
      1 ->
        Enum.at(split_url, 0)
      2 ->
        Regex.split(~r/[^0-9a-z_\-]/i, Enum.at(split_url, 1))
        |> Enum.at(0)
    end
  end
end
