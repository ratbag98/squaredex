defmodule SquaredexWeb.Component do
  @moduledoc """
  Useful components for HTML wrangling or other nefarious purposes
  """
  use Phoenix.Component

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
end
