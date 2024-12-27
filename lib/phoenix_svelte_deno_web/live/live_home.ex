defmodule PhoenixSvelteDenoWeb.ChatLive do
  alias PhoenixSvelteDeno.TodoCache
  use PhoenixSvelteDenoWeb, :live_view
  use PhoenixSvelteDenoWeb, :verified_routes

  def render(assigns) do
    ~H"""
    <.svelte name="Home" props={%{todos: @todos}} socket={@socket} />
    """
  end

  def mount(%{}, %{}, socket) do
    todos = TodoCache.list_todos()
    if connected?(socket), do: Phoenix.PubSub.subscribe(PhoenixSvelteDeno.PubSub, "session_data")

    {:ok, assign(socket, todos: todos)}
  end

  def handle_event("toggle_todo", %{"id" => id}, socket) do
    TodoCache.toggle_todo_done(id)
    {:noreply, socket}
  end

  def handle_event("add_todo", %{"text" => text}, socket) do
    TodoCache.add_todo(text)
    {:noreply, socket}
  end

  def handle_event("delete_todo", %{"id" => id}, socket) do
    TodoCache.delete_todo(id)
    {:noreply, socket}
  end

  def handle_info(:todos_updated, socket) do
    todos = TodoCache.list_todos()
    {:noreply, push_event(socket, "todos_update", %{todos: todos})}
  end
end
