defmodule MusicVoter.Song do
  defstruct [:id, :score, :title, :url]

  def new(url) do
    %__MODULE__{
      id: :rand.uniform(10000) + :rand.uniform(500),
      score: 1,
      url: url,
      title: MusicVoter.YouTube.title(url),
    }
  end
end
