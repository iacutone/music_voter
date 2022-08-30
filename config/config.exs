# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :music_voter, MusicVoterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pSIGJw4YD7MIm8EBD0vvJ8StWmSk+IRbBqB87k79qkYynMJFXNQdnBjl+G/15g1Z",
  render_errors: [view: MusicVoterWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: MusicVoter.PubSub,
  live_view: [signing_salt: "5EapYe9WpWIhqErxbkbSlFZry1+gKiqP"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Render leex files with LiveView Engine
config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
