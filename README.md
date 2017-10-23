# SGC.Umbrella

## Dev Setup

Requirements:
- Elixir
- Postgres
- NodeJS/NPM (for frontend assets)
- [direnv (optional)](https://direnv.net/)

Step by step:
- Clone this repo
- `cp .envrc.dist .envrc` (if using direnv, otherwise make sure the env vars from `.envrc.dist` are set)
- `mix deps.get`
- `mix ecto.create`
- `mix ecto.migrate`
- `npm install` in `apps/sgc_web/assets`

Run in interactive dev mode:

```
$ iex -S mix phx.server
```

Run tests:

```
$ mix test
```
