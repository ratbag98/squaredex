defmodule SquaredexWeb.Component do
  use Phoenix.Component

  def letter(%{letter: "_"} = assigns) do
    ~H"""
    <div class="blank rounded-xl box-border p-4 border-0 ">
      &nbsp;
    </div>
    """
  end

  def letter(assigns) do
    ~H"""
    <div
      id={@id}
      class="letter text-black text-5xl font-semibold rounded-xl p-4 flex justify-center items-center box-border border-4 border-gray-800"
    >
      <%= @letter %>
    </div>
    """
  end
end
