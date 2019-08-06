defmodule MusicVoter.YouTube do
  def search(query) do
    key = System.get_env("YOUTUBE_API_KEY")
    youtube_v3_url = "https://www.googleapis.com/youtube/v3/"
    query = URI.encode(query)
    search = "#{youtube_v3_url}search?part=snippet&maxResults=5&q=#{query}&type=video&key=#{key}"

    %{body: body} = HTTPoison.get!(search)
    decoded = Poison.decode!(body)
    decoded["items"]
  end
end

## Use this for testing in order to not hit the API

# [
#   %{
#     "etag" => "\"Bdx4f4ps3xCOOo1WZ91nTLkRZ_c/3LVpR1-Hk1vnBzPg5oAx8vuFShQ\"",
#     "id" => %{"kind" => "youtube#video", "videoId" => "LPTlvQ1Zet0"},
#     "kind" => "youtube#searchResult",
#     "snippet" => %{
#       "channelId" => "UCJTWqqBgwNNzF3p-YwPApKA",
#       "channelTitle" => "21SavageVEVO",
#       "description" => "\"Without Warning\" available at http://smarturl.it/WithoutWarning 21 Savage online: https://twitter.com/21savage https://www.instagram.com/21savage ...",
#       "liveBroadcastContent" => "none",
#       "publishedAt" => "2018-03-01T14:00:02.000Z",
#       "thumbnails" => %{
#         "default" => %{
#           "height" => 90,
#           "url" => "https://i.ytimg.com/vi/LPTlvQ1Zet0/default.jpg",
#           "width" => 120
#         },
#         "high" => %{
#           "height" => 360,
#           "url" => "https://i.ytimg.com/vi/LPTlvQ1Zet0/hqdefault.jpg",
#           "width" => 480
#         },
#         "medium" => %{
#           "height" => 180,
#           "url" => "https://i.ytimg.com/vi/LPTlvQ1Zet0/mqdefault.jpg",
#           "width" => 320
#         }
#       },
#       "title" => "21 Savage, Offset, Metro Boomin - Ric Flair Drip (Official Music Video)"
#     }
#   },
#   %{
#     "etag" => "\"Bdx4f4ps3xCOOo1WZ91nTLkRZ_c/P7nFZfURZCzYeQ1nG0UvFOBM3qE\"",
#     "id" => %{"kind" => "youtube#video", "videoId" => "UkoUJZ-uR6Y"},
#     "kind" => "youtube#searchResult",
#     "snippet" => %{
#       "channelId" => "UCeiafQtjn-SfkAcH2Af-Aqg",
#       "channelTitle" => "RicHassaniVEVO",
#       "description" => "Music video for Beautiful To Me (Audio) performed by Ric Hassani. \"Beautiful To Me\" is taken from the new album, The African Gentleman, available now ...",
#       "liveBroadcastContent" => "none",
#       "publishedAt" => "2017-09-01T07:00:01.000Z",
#       "thumbnails" => %{
#         "default" => %{
#           "height" => 90,
#           "url" => "https://i.ytimg.com/vi/UkoUJZ-uR6Y/default.jpg",
#           "width" => 120
#         },
#         "high" => %{
#           "height" => 360,
#           "url" => "https://i.ytimg.com/vi/UkoUJZ-uR6Y/hqdefault.jpg",
#           "width" => 480
#         },
#         "medium" => %{
#           "height" => 180,
#           "url" => "https://i.ytimg.com/vi/UkoUJZ-uR6Y/mqdefault.jpg",
#           "width" => 320
#         }
#       },
#       "title" => "Ric Hassani - Beautiful To Me (Audio)"
#     }
#   }
# ]
