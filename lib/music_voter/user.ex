defmodule MusicVoter.User do

  
  @enforce_keys [:name, :votes]
  defstruct [:name, :votes]

  @doc """
  Creates a user with the given `name`
  """
  def new(name) do
    %__MODULE__{
      name: name,
      votes: 10
    }
  end
end
