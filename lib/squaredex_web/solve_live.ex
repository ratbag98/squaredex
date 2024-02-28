defmodule SquaredexWeb.SolveLive do
  use SquaredexWeb, :live_view
  import SquaredexWeb.Component

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       puzzle_letters: "",
       padding: 0,
       class: grid_class(0),
       solution_path: [],
       manual_path: ""
     )}
  end

  def render(assigns) do
    ~H"""
    <h1 class="font-bold text-2xl">Squaredex</h1>

    <div class="letters_form">
      <form phx-submit="submit" phx-change="refresh">
        <.label>Enter the puzzle letters, use "_" for a gap.</.label>
        <.input
          type="text"
          id="custom-letter-input"
          name="puzzle_letters"
          value={@puzzle_letters}
          phx-hook="LettersAndUnderscores"
          autocomplete="off"
          autocapitalize="off"
          spellcheck="false"
        />
        <.label>Provide a list of ids to connect</.label>
        <.input type="text" id="manual-path" name="manual-path" value={@manual_path} />
        <.button>Submit</.button>
        <.non_submit phx-click="clear">
          Clear Path
        </.non_submit>
      </form>
    </div>

    <div class="relative">
      <canvas
        id="grid-overlay"
        class="h-full w-full pointer-events-none absolute top-0 left-0 z-10 aspect-square opacity-25"
        )
      />
      <.letters_grid
        id="solvable_grid"
        class={@class}
        puzzle_letters={@puzzle_letters}
        padding={@padding}
        solution_path={@solution_path}
      />
    </div>
    """
  end

  # Tailwind dynamic classes. Don't remove this comment
  # <div class="grid-rows-1 grid-cols-1" />
  # <div class="grid-rows-2 grid-cols-2" />
  # <div class="grid-rows-3 grid-cols-3" />
  # <div class="grid-rows-4 grid-cols-4" />
  # <div class="grid-rows-5 grid-cols-5" />
  # <div class="grid-rows-6 grid-cols-6" />
  # <div class="grid-rows-7 grid-cols-7" />
  # <div class="grid-rows-8 grid-cols-8" />
  # <div class="grid-rows-9 grid-cols-9" />
  # <div class="grid-rows-10 grid-cols-10" />
  # BY INCLUDING THIS COMMENT, THE TAILWIND CLASSES WILL BE INCLUDED IN app.css

  def handle_event("refresh", %{"puzzle_letters" => puzzle_letters}, socket) do
    # should already be done by front-end. Belt and braces
    puzzle_letters = String.replace(puzzle_letters, ~r"[^A-Z_]", "")

    # pad the string to a square number of letters (eg 9, 16, 25 etc.)
    letters = String.graphemes(puzzle_letters)
    length = length(letters)
    side = minimal_side(length)

    {:noreply,
     assign(socket,
       puzzle_letters: puzzle_letters,
       paddiing: side * side - length,
       class: grid_class(side)
     )}
  end

  def handle_event("submit", %{"manual-path" => manual_path}, socket) do
    manual_path = String.replace(manual_path, ~r"[^0-9, ]", "")

    # fake solve, just want to check path drawing logic
    {:noreply,
     assign(socket, manual_path: manual_path, solution_path: parse_manual_path(manual_path))}
  end

  def handle_event("clear", _, socket) do
    # fake solve, just want to check path drawing logic
    {:noreply, assign(socket, solution_path: [], manual_path: "")}
  end

  defp parse_manual_path(""), do: []

  defp parse_manual_path(path) do
    path
    |> String.split(~r"[ ,]")
    |> Enum.map(&String.to_integer/1)
  end

  # the smallest square side length that fits the current letters
  defp minimal_side(len) do
    side = trunc(:math.sqrt(len))
    if side * side < len, do: side + 1, else: side
  end

  # adjust the Tailwind class
  defp grid_class(side),
    do:
      "bg-gray-100 rounded-2xl shadow-lg grid grid-rows-#{side} grid-cols-#{side} aspect-square gap-4 p-4 z-0"
end
