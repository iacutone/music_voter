defmodule MusicVoter.Comment do
  defstruct [:user, :text]

  def new(user, text) do
    %__MODULE__{
      user: user,
      text: text
    }
  end
end
