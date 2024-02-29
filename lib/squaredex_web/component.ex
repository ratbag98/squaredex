defmodule SquaredexWeb.Component do
  @moduledoc """
  Useful components for HTML wrangling or other nefarious purposes
  """
  use Phoenix.Component

  defp cell_class, do: "rounded-xl p-4"

  defp generic_letter_class,
    do: "#{cell_class()} flex justify-center items-center box-border border text-5xl"

  defp dull_letter_class,
    do: "#{generic_letter_class()} bg-gray-300 text-black font-bold border-gray-500"

  defp active_letter_class,
    do:
      "#{generic_letter_class()} bg-gray-100 text-red-500 font-semibold border-gray-600 border-4 drop-shadow-xl"

  attr :id, :string, required: true, doc: "the id of this letter in the grid"
  attr :letter, :string, required: true
  attr :class, :string, default: nil
  attr :path_position, :integer, doc: "where this letter appears in solution path, if anywhere"

  @doc """
   Renders a letter in the grid. If the letter is "_" it renders a blank

  ## Examples

    <.letter id="letter_1" letter="_" />
    <.letter id="letter_2" letter="Q" />
    <.letter id="letter_3" letter="Z" path_position=4 />
  """
  def letter(%{letter: "_"} = assigns) do
    ~H"""
    <div class={[cell_class(), @class]}>&nbsp;</div>
    """
  end

  # dull letter
  def letter(%{path_position: nil} = assigns) do
    ~H"""
    <div id={@id} class={[dull_letter_class(), @class]}>
      <%= @letter %>
    </div>
    """
  end

  def letter(assigns) do
    ~H"""
    <div id={@id} class={[active_letter_class(), @class]} path-index={@path_position}>
      <%= @letter %>
    </div>
    """
  end

  @doc """
  Renders a non-submit button.

  ## Examples

      <.non_submit>Clear</.non_submit>
      <.non_submit phx-click="reset" class="ml-2">reset</.non_submit>
  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def non_submit(assigns) do
    ~H"""
    <.link
      class={[
        "rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  @doc """
  Render a grid of letters, capable of being solved
  """

  attr :id, :string, required: true
  attr :class, :string, required: true
  attr :puzzle_letters, :string, required: true
  attr :padding, :string, required: true
  attr :solution_path, :list, default: []

  def letters_grid(assigns) do
    ~H"""
    <div class={@class} phx-hook="DrawGridPath" id={@id}>
      <.letter
        :for={
          {letter, index} <-
            Enum.with_index(String.graphemes(@puzzle_letters) ++ List.duplicate("_", @padding))
        }
        id={"letter_#{index}"}
        letter={letter}
        path_position={Enum.find_index(@solution_path, fn i -> index == i end)}
      />
    </div>
    """
  end
end
