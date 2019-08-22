defmodule MusicVoterWeb.Presence do
  use Phoenix.Presence,
    otp_app: :music_voter,
    pubsub_server: MusicVoter.PubSub
end
