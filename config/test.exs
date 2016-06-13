use Mix.Config

config :ueberauth, Ueberauth,
  providers: [
    active_directory: { Ueberauth.Strategy.ActiveDirectory, [] },
  ]
