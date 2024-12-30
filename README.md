# PhoenixSvelteDeno

Ejemplo de aplicación Phoenix que usa LiveSvelte con Deno como runtime.

## Resultados de benchmark

```markdown
### deno
[info] Rendering in Deno took 4244 µs // initial render
[info] Rendering in Deno took 386 µs // refresh
[info] Rendering in Deno took 404 µs // with a single todo

### nodejs 22
[info] Rendering in Node took 9442 µs // initial render
[info] Rendering in Node took 1278 µs // refresh
[info] Rendering in Node took 1280 µs // with a single todo
```

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
