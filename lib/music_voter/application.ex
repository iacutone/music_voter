defmodule MusicVoter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Phoenix.PubSub, name: MusicVoter.PubSub},
      MusicVoterWeb.Presence,
      supervisor(MusicVoterWeb.Endpoint, []),
      supervisor(MusicVoter.SongList, []),
      supervisor(MusicVoter.SongTracker, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MusicVoter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MusicVoterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
