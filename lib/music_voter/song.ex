defmodule MusicVoter.Song do
  defstruct [:id, :score, :title, :url, :vid, :comments, :votes]

  def new(vid, title) do
    %__MODULE__{
      id: :rand.uniform(10000) + :rand.uniform(500),
      score: 1,
      url: "https://www.youtube.com/watch?v=#{vid}",
      vid: vid,
      title: title,
      comments: [],
      votes: []
    }
  end
end
