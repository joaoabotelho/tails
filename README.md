# Tails

## Requirements

You need the following to run tails:

- erlang
- elixir
- postgres
- nodejs (linting, CLI tools and frontend)

### Installing natively (via asdf)

With [asdf](https://github.com/asdf-vm/asdf) you can just run `asdf install` and it should install the plugins and the correct versions of elixir, erlang, postgres and redis (see `.tool-versions`). Most likely you will need some extra options for postgres so `POSTGRES_EXTRA_CONFIGURE_OPTIONS=--with-uuid=e2fs asdf install` is recommended.

#### Notes for upgrading erlang/elixir

If you're running the tails app locally and receive a message about missing erlang or elixir version,
just install the suggested version.
For new versions of MacOS and asdf everything should go flawlessly.

If you experience any issues during compilation or see a lot of warning from libraries that should be already deleted, try cleaning dependencies and compiled files first:

```
mix deps.clean --all
rm -rf _build/*
```
##### Running

If running `postgres`/`pg_ctl start` or `brew services start postgresql` (if installed via brew) does not work try the following command:

`pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`

Don't forget to run setup as a first time user:

##### Postgres Setup

For postgres, also make sure to follow the [postgres setup instructions](https://github.com/smashedtoatoms/asdf-postgres#run) (specifically creating a DB), basically:

1. Start postgres (see previous section)
2. `createdb <username>` (leaving `<username>` empty should pick up your current username)


##### Troubleshooting

If running `mix ecto.reset` raises an role issue run: `psql -c "CREATE USER postgres SUPERUSER;"`

If encounter issue where `uuid-ossp` cannot be found when running `mix ecto.reset` with Postgres installed by `asdf`:

1. uninstall current Postgres
   `asdf uninstall postgres 13.7`
2. install with following command
   `POSTGRES_EXTRA_CONFIGURE_OPTIONS=--with-uuid=e2fs asdf install postgres 13.7`
3. setup Postgres again

If Postgres installed by `asdf` and you're having troubles to run it, [this](https://github.com/smashedtoatoms/asdf-postgres#run) may help.

If Postgres is missing `postgres` role:

```
FATAL:  role "postgres" does not exist
```

Execute the following command and restart the server:

```
createuser postgres -s
```

## Running Tails API

To start your Phoenix server:

- Get secrets ready `touch .env.dev`
- Grab `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` values from Google OATH. You should only have to do this once. And add them to your local `.env.dev`.
- Run in terminal `source .env.dev`
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Production release
Generate a secret for our Phoenix app
- `mix phx.gen.secret`

It will output a very long string. Something like this: `B41pUFgfTJeEUpt+6TwSkbrxlAb9uibgIemaYbm1Oq+XdZ3Q96LcaW9sarbGfMhy`
Now export this secret as a environment variable: 
- `export SECRET_KEY_BASE=B41pUFgfTJeEUpt+6TwSkbrxlAb9uibgIemaYbm1Oq+XdZ3Q96LcaW9sarbGfMhy`

Export the database URL. Probably very different in production for you.
I'm just using the local postgreSQL dev instance for this demo
- `export DATABASE_URL=ecto://postgres:postgres@localhost/phoenix_react_dev`

Get production dependencies
- `mix deps.get --only prod`

Compile the project for production
`MIX_ENV=prod mix compile`

Generate static assets in case you are using Phoenix default assets pipelines For serve-side rendered pages
- `MIX_ENV=prod mix assets.deploy`

Generate our React frontend using our custom mix task
- `mix webapp`

Genereate the convenience scripts to assist Phoenix applicaiton deployments like running ecto migrations
- `mix phx.gen.release`

Now we are ready to generate the Elixir Release
- `MIX_ENV=prod mix release`

We now have our production release ready. Let’s fire it up with the following command:

- `PHX_HOST=localhost _build/prod/rel/phoenix_react/bin/phoenix_react start`

