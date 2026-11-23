defmodule MusicVoter.HTTPClient do
  @moduledoc """
  Behaviour for the HTTP client used to talk to external APIs.

  The real implementation wraps HTTPoison; tests swap in a Mox mock
  (see `config/test.exs` and `test/test_helper.exs`).
  """

  @callback get!(url :: String.t()) :: %{status_code: integer(), body: String.t()}

  @callback post(url :: String.t(), body :: String.t()) :: {:ok, map()} | {:error, term()}

  @doc false
  def impl, do: Application.get_env(:music_voter, :http_client, MusicVoter.HTTPClient.HTTPoison)

  def get!(url), do: impl().get!(url)
  def post(url, body), do: impl().post(url, body)
end
