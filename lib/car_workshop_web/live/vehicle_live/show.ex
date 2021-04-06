defmodule CarWorkshopWeb.VehicleLive.Show do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Vehicles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:vehicle, Vehicles.get_vehicle!(id))}
  end

  defp page_title(:show), do: "Show Vehicle"
  defp page_title(:edit), do: "Edit Vehicle"
end
