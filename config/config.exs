# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dostup,
  token_life_time_hours: 288,
  ecto_repos: [
    Dostup.Persistence.Repo
  ],
  emails: [
    register_subj: "Уведомление о регистрации в системе",
    activation_subj: "Ваша учетная запись активирована",
    new_password_subj: "Новые данные для авторизации"
    #from: email address secret
  ]

config :dostup, Dostup.Services.Email.Mailer,
  adapter: Bamboo.SMTPAdapter

# Configures the endpoint
config :dostup, DostupWeb.Endpoint,
  url: [host: "localhost"],
  #secret_key_base: xxxx secret
  render_errors: [view: DostupWeb.ErrorView, accepts: ~w(json), layout: false]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  colors: [enabled: true]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pdf_generator,
  raise_on_missing_wkhtmltopdf_binary: false,
  raise_on_missing_chrome_binary: true,
  #chrome_path: "/root/.nvm/versions/node/v12.18.3/bin/chrome-headless-render-pdf",
  #node_path: "/root/.nvm/versions/node/v12.18.3/bin/node",
  #delete_temporary: true,
  generator: :chrome,
  use_chrome: true,                           # <-- make sure you installed node/puppeteer
  prefer_system_executable: true,
  disable_chrome_sandbox: true,
  no_sandbox: true

config :gettext, :default_locale, "ru"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "all.secret.exs"
import_config "#{Mix.env()}.exs"
import_config "#{Mix.env()}.secret.exs"
