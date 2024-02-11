defmodule SquaredexWeb.SolveLive do
  use SquaredexWeb, :live_view
  import SquaredexWeb.Component

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       letters: [],
       all_letters: "",
       class: grid_class(0),
       solution_path: [0, 1, 2, 4]
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Squaredex</h1>

    <div class="letters_form">
      <form phx-submit="submit" phx-change="refresh">
        <.label>Enter the puzzle letters, use "_" for a gap</.label>
        <.input
          type="text"
          id="custom-letter-input"
          name="all_letters"
          value={@all_letters}
          phx-hook="LettersAndUnderscores"
          autocomplete="off"
          autocapitalize="off"
          spellcheck="false"
        />
        <.button>Submit</.button>
      </form>
    </div>

    <div class={@class} id="letters_grid" phx-hook="DrawGridPath">
      <%= Enum.with_index(@letters, fn letter, index -> %>
        <.letter
          letter={letter}
          id={"letter_#{index}"}
          path_position={Enum.find_index(assigns.solution_path, fn i -> index == i end)}
        />
      <% end) %>
    </div>

    <%!-- these are necessary to get Tailwind to include the classes --%>
    <div class="grid-rows-1 grid-cols-1" />
    <div class="grid-rows-2 grid-cols-2" />
    <div class="grid-rows-3 grid-cols-3" />
    <div class="grid-rows-4 grid-cols-4" />
    <div class="grid-rows-5 grid-cols-5" />
    <div class="grid-rows-6 grid-cols-6" />
    <div class="grid-rows-7 grid-cols-7" />
    <div class="grid-rows-8 grid-cols-8" />
    <div class="grid-rows-9 grid-cols-9" />
    <div class="grid-rows-10 grid-cols-10" />
    """
  end

  def handle_event("refresh", %{"all_letters" => all_letters}, socket) do
    # should already be done by front-end. Belt and braces
    all_letters = String.replace(all_letters, ~r"[^A-Z_]", "")

    # pad the string to a square number of letters (eg 9, 16, 25 etc.)
    letters = String.split(all_letters, "", trim: true)
    length = length(letters)
    side = minimal_side(length)

    padding = List.duplicate("_", side * side - length)
    letters = letters ++ padding

    {:noreply,
     assign(socket,
       all_letters: all_letters,
       letters: letters,
       class: grid_class(side)
     )}
  end

  def handle_event("submit", _, socket) do
    # fake solve, just want to check path drawing logic
    {:noreply, assign(socket, solution_path: [0, 1, 2, 4])}
  end

  # the smallest square side length that fits the current letters
  defp minimal_side(len) do
    side = trunc(:math.sqrt(len))
    if side * side < len, do: side + 1, else: side
  end

  # adjust the Tailwind class
  defp grid_class(side),
    do:
      "bg-gray-300 rounded-2xl shadow-lg grid grid-rows-#{side} grid-cols-#{side} aspect-square gap-4 p-4"
end
