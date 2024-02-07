defmodule SquaredexWeb.SolveLive do
  use SquaredexWeb, :live_view
  alias SquaredexWeb.Component

  def mount(_params, _session, socket) do
    # letters = [
    #   "A",
    #   "Q",
    #   "E",
    #   "R",
    #   "D",
    #   "E",
    #   "H",
    #   "A",
    #   "W",
    #   "U",
    #   "M",
    #   "E",
    #   "N",
    #   "A",
    #   "_",
    #   "E"
    # ]
    #
    # side = trunc(:math.sqrt(length(letters)))
    # diff = length(letters) - side * side
    #
    # if diff == 0 do
    #   real_side = side
    # else
    #   real_side = side + 1
    # end

    {:ok,
     assign(socket,
       letters: [],
       all_letters: "",
       class: grid_class(0)
     )}
  end

  def minimal_side(len) do
    side = trunc(:math.sqrt(len))
    if side * side < len, do: side + 1, else: side
  end

  def grid_class(side),
    do:
      "letters bg-gray-300 rounded-2xl shadow-lg grid grid-rows-#{side} grid-cols-#{side} aspect-square gap-4 p-4"

  def handle_event("refresh", %{"all_letters" => all_letters}, socket) do
    all_letters = String.replace(all_letters, ~r"[^A-Z_]", "")
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

  def render(assigns) do
    ~H"""
    <h1>Squaredex</h1>

    <div class="letters_form">
      <.form phx-submit="submit" phx-change="refresh">
        <.label>Enter the puzzle letters, use "_" for a gap</.label>
        <.input type="text" name="all_letters" value={@all_letters} />
        <.button>Submit</.button>
      </.form>
    </div>

    <div class={@class}>
      <%= for letter <- @letters do %>
        <Component.letter letter={letter} id={letter} />
      <% end %>
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
end
