# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :car_workshop,
  ecto_repos: [CarWorkshop.Repo]

# Configures the endpoint
config :car_workshop, CarWorkshopWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nemsDow6vJuxkaodnr6n60/LyempK2fRcXu4+elLA84NEENKx0jA67Mg9aHYpcO3",
  render_errors: [view: CarWorkshopWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CarWorkshop.PubSub,
  live_view: [signing_salt: "C/yZ2+/t"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

drive_folder_id =
  System.get_env("DRIVE_FOLDER_ID") ||
    raise """
    environment variable DRIVE_FOLDER_ID is missing.
    """

config :car_workshop, :drive_parent_id, drive_folder_id
