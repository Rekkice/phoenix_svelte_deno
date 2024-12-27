<script lang="ts">
  import { onMount } from "svelte";

  export let live;
  export let todos;

  let newTodo = "";

  function addTodo() {
    if (!newTodo.trim()) return
    live.pushEvent("add_todo", {
      text: newTodo
    })
    newTodo = "";
  }

  function toggleTodo(todo) {
    live.pushEvent("toggle_todo", {
      id: todo.id
    })
  }

  function deleteTodo(todo) {
    live.pushEvent("delete_todo", {
      id: todo.id
    })
  }

  onMount(() => {
    if (!live) return
    live.handleEvent("todos_update", (data) => {
      todos = data.todos
    })
  });
</script>

<main class="h-full flex justify-center items-center">
  <div class="bg-white shadow-lg rounded-lg p-8 max-w-xl">
    <h1 class="text-2xl font-bold mb-4 text-gray-800">Lista de tareas</h1>
    
    <form on:submit|preventDefault={addTodo} class="flex gap-2 mb-4">
      <input
        type="text"
        placeholder="Agregar una tarea..."
        bind:value={newTodo}
        class="flex-1 px-4 py-2 border rounded-lg shadow-sm focus:outline-none focus:ring focus:ring-blue-300"
        maxlength=25
      />
      <button
        class="px-4 py-2 bg-blue-500 text-white rounded-lg shadow hover:bg-blue-600 transition"
      >
        Agregar
      </button>
    </form>
    
    <ul>
      {#each todos as todo}
        <li
          class="flex items-center justify-between px-4 py-2 mb-2 bg-gray-50 border rounded-lg shadow-sm"
        >
          <span
            class="flex-1 cursor-pointer"
            class:line-through={todo.done}
            on:click={() => toggleTodo(todo)}
          >
            {todo.text}
          </span>
          <button
            on:click={() => deleteTodo(todo)}
            class="ml-4 px-2 py-1 bg-red-500 text-white rounded hover:bg-red-600"
          >
            Eliminar
          </button>
        </li>
      {/each}
    </ul>
  </div>
</main>
