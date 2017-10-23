# SGC.Umbrella

## Dev Setup

Requirements:
- Elixir
- Postgres
- [direnv (optional)](https://direnv.net/)

Step by step:
- Clone this repo
- `cp .envrc.dist .envrc` (if using direnv, otherwise make sure the env vars from `.envrc.dist` are set)
- `mix deps.get`
- `mix ecto.create`
- `mix ecto.migrate`

Run in interactive dev mode:

```
$ iex -S mix phx.server
```

Run tests:

```
$ mix test
```
