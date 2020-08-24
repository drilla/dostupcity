use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dostup, Dostup.Persistence.Repo,
 database: "dostup_test",
 hostname: "db",
 show_sensitive_data_on_connection_error: true,
 # username: secret,
 # password: secret,
 pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dostup, DostupWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :debug

config :dostup, Dostup.Services.Email.Mailer,
  adapter: Bamboo.LocalAdapter
