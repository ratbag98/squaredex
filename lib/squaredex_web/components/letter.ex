defmodule SquaredexWeb.Letter do
  use SquaredexWeb, :live_component

  def render(%{letter: " "} = assigns) do
    ~H"""
    <div class="letter text-black text-5xl rounded-xl font-semibold box-border p-4 border-0 flex justify-center items-center">
      &nbsp;
    </div>
    """
  end

  def render(%{letter: letter} = assigns) do
    ~H"""
    <div class="letter text-black text-5xl rounded-xl font-semibold box-border p-4 border-gray-800 border-4 flex justify-center items-center">
      <%= letter %>
    </div>
    """
  end
end
