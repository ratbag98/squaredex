defmodule SquaredexWeb.SolveLive do
  use SquaredexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, letters: "")}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1>Squaredex</h1>
    <div class="letters bg-gray-300 rounded-2xl shadow-lg grid grid-flow-row gap-4 grid-rows-4 grid-cols-4 aspect-square p-4">
      <.live_component module={SquaredexWeb.Letter} letter="A" id="1" />
      <.live_component module={SquaredexWeb.Letter} letter="Q" id="2" />
      <.live_component module={SquaredexWeb.Letter} letter="E" id="3" />
      <.live_component module={SquaredexWeb.Letter} letter="R" id="4" />
      <.live_component module={SquaredexWeb.Letter} letter="D" id="5" />
      <.live_component module={SquaredexWeb.Letter} letter="E" id="6" />
      <.live_component module={SquaredexWeb.Letter} letter="H" id="7" />
      <.live_component module={SquaredexWeb.Letter} letter="A" id="8" />
      <.live_component module={SquaredexWeb.Letter} letter="V" id="9" />
      <.live_component module={SquaredexWeb.Letter} letter="T" id="10" />
      <.live_component module={SquaredexWeb.Letter} letter="M" id="11" />
      <.live_component module={SquaredexWeb.Letter} letter="E" id="12" />
      <.live_component module={SquaredexWeb.Letter} letter="N" id="13" />
      <.live_component module={SquaredexWeb.Letter} letter="A" id="14" />
      <.live_component module={SquaredexWeb.Letter} letter=" " id="15" />
      <.live_component module={SquaredexWeb.Letter} letter="E" id="16" />
    </div>
    """
  end
end
