defmodule MusicVoter.YouTube do
    key = System.get_env("YOUTUBE_API_KEY")
    youtube_v3_url = "https://www.googleapis.com/youtube/v3/"
    query = URI.encode(query)
    search = "#{youtube_v3_url}search?part=snippet&maxResults=5&q=#{query}&type=video&key=#{key}"

    %{body: body} = HTTPoison.get!(search)
    IO.inspect body
    decoded = Poison.decode!(body)
    decoded["items"]
  end
end
