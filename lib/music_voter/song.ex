defmodule MusicVoter.Song do
  @enforce_keys [:url, :score]
  defstruct [:url, :score]
end
