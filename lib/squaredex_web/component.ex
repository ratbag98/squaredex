defmodule SquaredexWeb.Component do
  @moduledoc """
  Useful components for HTML wrangling or other nefarious purposes
  """
  use Phoenix.Component

  defp cell_class, do: "rounded-xl p-4"

  defp generic_letter_class,
    do: "#{cell_class()} flex justify-center items-center box-border border-4"

  defp dull_letter_class,
    do: "#{generic_letter_class()} text-black text-5xl font-bold border-gray-800"

  defp active_letter_class,
    do:
      "#{generic_letter_class()} bg-gray-200 text-red-500 text-5xl font-semibold border-gray-500"

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
end
