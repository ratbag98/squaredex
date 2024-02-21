defmodule SquaredexWeb.Component do
  @moduledoc """
  Useful components for HTML wrangling or other nefarious purposes
  """
  use Phoenix.Component

  attr :letter, :string, default: "_"
  attr :id, :string, required: true, doc: "the id of this letter in the grid"

  attr :path_position, :list,
    default: [],
    doc: "where this letter appears in solution path, if anywhere"

  def letter(%{letter: "_"} = assigns) do
    ~H"""
    <div class="blank rounded-xl box-border p-4 border-0 ">
      &nbsp;
    </div>
    """
  end

  # dull letter
  def letter(%{path_position: nil} = assigns) do
    ~H"""
    <div
      id={@id}
      class="text-black text-5xl font-bold rounded-xl p-4 flex justify-center items-center box-border border-4 border-gray-800"
    >
      <%= @letter %>
    </div>
    """
  end

  def letter(assigns) do
    ~H"""
    <div
      id={@id}
      class="bg-gray-200 text-red-500 text-5xl font-semibold rounded-xl p-4 flex justify-center items-center box-border border-4 border-gray-500"
      path-index={@path_position}
    >
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
