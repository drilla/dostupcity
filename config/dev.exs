use Mix.Config


# Configure your database
config :dostup, Dostup.Persistence.Repo,
 database: "dostup",
 hostname: "db",
 show_sensitive_data_on_connection_error: false,
 pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :dostup, DostupWeb.Endpoint,
  http: [
    port: 4000,
    transport_options: [
      num_acceptors: 10_000,
      max_connections: 100_000
    ]
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger,
  format: "[$level] $message\n",
  level: :debug
  #  backends: [{LoggerFileBackend, :debug}, {LoggerFileBackend, :error}]

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :logger, :error,
  path: "logs/error.log",
  level: :error

config :logger, :debug,
  path: "logs/debug.log",
  level: :debug

config :dostup, Dostup.Services.Email.Mailer,
 #server: secret,
 #hostname: secret,
 port: 465,
 tls: :never, # can be `:always` or `:never`
 allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2", :"tlsv1.3"], # or {:system, "ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
 ssl: true, # can be `true`
 retries: 10,
 no_mx_lookups: false, # can be `true`
 auth: :always
