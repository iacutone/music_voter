defmodule MusicVoter.HTTPClient.HTTPoison do
  @behaviour MusicVoter.HTTPClient

  @impl true
  def get!(url), do: HTTPoison.get!(url)

  @impl true
  def post(url, body), do: HTTPoison.post(url, body)
end
