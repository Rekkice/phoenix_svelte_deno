defmodule PhoenixSvelteDenoWeb.SSR.Deno do
  require Logger
  @behaviour LiveSvelte.SSR

  def render(name, props, slots) do
    {duration, result} =
      :timer.tc(fn ->
        try do
          name_json = Jason.encode!(name)
          props_json = Jason.encode!(props)
          slots_json = Jason.encode!(slots)

          {:ok, body} =
            DenoRider.eval("globalThis.render(#{name_json}, #{props_json}, #{slots_json})")

          body
        catch
          :exit, {:noproc, _} ->
            message = """
            Deno is not configured. Please add the following to your application.ex:
            {DenoRider, [main_module_path: "priv/svelte/deno_entrypoint.js"]}
            """

            raise %LiveSvelte.SSR.NotConfigured{message: message}
        end
      end)

    Logger.info("Rendering in Deno took #{duration} µs")

    result
  end

  def server_path() do
    {:ok, path} = :application.get_application()
    Application.app_dir(path, "/priv/svelte")
  end
end
