# UeberauthActiveDirectory

Active Directory [Ueberauth](https://github.com/ueberauth/ueberauth) strategy using [Exldap](https://github.com/jmerriweather/exldap).

## Installation

Add ueberauth_active_directory to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ueberauth_active_directory, "~> 0.0.1"}]
end
```

Ensure ueberauth_active_directory is started before your application:

```elixir
def application do
  [applications: [:ueberauth_active_directory]]
end
```

Run `mix deps.get`

## Usage

Add AD server information to `<mix env>.secret.exs`

Config Value | Usage
------------ | -----
server | Your Active Directory server address
base |   Base distingushed name for your domain. e.g. lab.local would be `DC=lab,DC=local`
port | Ldap listening port
ssl | Enable SSL
user_dn | Bind account username in distinguishedName format
password | Bind account password

```elixir
# config/dev.secret.exs

config :ueberauth, Ueberauth.Strategy.ActiveDirectory.Ldap,
  server: "192.168.250.2",
  base: "DC=lab,DC=local",
  port: 389,
  ssl: false,
  user_dn: "CN=vagrant,CN=Users,DC=lab,DC=local",
  password: "vagrant"
```

Configure Ueberauth to use the strategy

```elixir
# config/dev.exs

config :ueberauth, Ueberauth,
  providers: [
    active_directory: { Ueberauth.Strategy.ActiveDirectory, [] },
  ]
```

Configure authentication routes

```elixir
scope "/auth", MyApp do
  pipe_though :browser

  get "/:provider", AuthController, :request
  get "/:provider/callback", AuthController, :callback
end
```

Include Überauth plug in your controller

```elixir
defmodule MyApp.AuthController do
  use MyApp.Web, :controller
  plug Ueberauth
  ...
end
```

## Tests
Tests require an AD environment to run.  The vagrantfile included in the repo will take care of setting up the environment for you. 
### Prerequisites
* [Vagrant](https://vagrantup.com)

### Running Tests
* Clone the repo
* `cd ueberauth_active_directory`
* Run `vagrant up`
* Run `mix test`
