defmodule CarWorkshopWeb.TextInputComponent do
  use CarWorkshopWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="relative w-full mb-3">
      <%= label @f, @id, @label, class: "block uppercase text-gray-600 text-xs font-bold mb-2" %>
      <%= text_input @f, @id,
        class: "border-0 px-3 py-3 placeholder-gray-300 text-gray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
      %>
      <%= error_tag @f, @id %>
    </div>
    """
  end
end
