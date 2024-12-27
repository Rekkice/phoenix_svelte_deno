defmodule PhoenixSvelteDeno.TodoCache do
  use GenServer
  alias Phoenix.PubSub

  @table :session_data
  @topic "session_data"

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :ets.new(@table, [:set, :protected, :named_table])
    {:ok, %{}}
  end

  defp broadcast_change() do
    PubSub.broadcast(PhoenixSvelteDeno.PubSub, @topic, :todos_updated)
  end

  def add_todo(text) do
    GenServer.call(__MODULE__, {:add, text})
    broadcast_change()
  end

  def delete_todo(id) do
    GenServer.call(__MODULE__, {:delete, id})
    broadcast_change()
  end

  def toggle_todo_done(id) do
    GenServer.call(__MODULE__, {:toggle, id})
    broadcast_change()
  end

  def list_todos() do
    GenServer.call(__MODULE__, :list)
  end

  @impl true
  def handle_call({:add, text}, _from, state) do
    id =
      case :ets.lookup(@table, :last_id) do
        [{:last_id, id}] -> id + 1
        [] -> 1
      end

    :ets.insert(@table, {id, %{id: id, text: text, done: false}})
    :ets.insert(@table, {:last_id, id})
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:delete, id}, _from, state) do
    :ets.delete(@table, id)
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:toggle, id}, _from, state) do
    case :ets.lookup(@table, id) do
      [{^id, todo}] ->
        done? = Map.get(todo, :done)
        updated_todo = %{todo | done: !done?}

        :ets.insert(@table, {id, updated_todo})
        {:reply, :ok, state}

      [] ->
        {:reply, :not_found, state}
    end
  end

  @impl true
  def handle_call(:list, _from, state) do
    todos =
      :ets.tab2list(@table)
      |> Enum.reject(fn {key, _} -> key == :last_id end)
      |> Enum.map(fn {_id, todo} -> todo end)

    {:reply, todos, state}
  end
end
