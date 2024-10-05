# TavoroMiniWms

## Tooling

Using `nix` and `direnv` all tooling is included out of the box:

1. [Install the `nix` package manager](https://nixos.org/download/)
1. Install `direnv`

   - on Linux you can do so with nix if you'd like: `nix-env -iA nixpkgs.direnv`
   - on MacOS it appears that homebrew is the best option

1. At this point once you enter the root project directory you should get a
   message asking you do run `direnv allow` (if you don't see thing you may
   need to [setup the `direnv` hook](https://direnv.net/docs/hook.html)).
   After you run `direnv allow`, `nix` will download Elixir and a couple
   other dependencies.
1. Lastly, you'll want a postgres server running. If you don't have one already
   you can run the `./start_postgres` script.

If you prefer to go your own route with tooling, you'll want to install Elixir
and Postgres.

## Learn more

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
