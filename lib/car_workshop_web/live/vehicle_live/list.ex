defmodule CarWorkshopWeb.VehicleLive.List do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Vehicles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :vehicles, list_vehicles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Vehículos Registrados")
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    vehicle = Vehicles.get_vehicle!(id)
    {:ok, _} = Vehicles.delete_vehicle(vehicle)

    {:noreply, assign(socket, :vehicles, list_vehicles())}
  end

  defp list_vehicles do
    Vehicles.list_vehicles()
  end
end
