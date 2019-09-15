defmodule MusicVoter.User do

  
  @enforce_keys [:name]
  defstruct [:name, :id]

  @doc """
  Creates a user with the given `name`
  """
  def new(name) do
    %__MODULE__{
      name: name,
      id: :rand.uniform(10000) + :rand.uniform(500),
    }
  end
end
