defmodule CarWorkshopWeb.VehicleLive.Show do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Vehicles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    vehicle = Vehicles.get_vehicle!(id)
    IO.inspect(vehicle)

    {:noreply,
     socket
     |> assign(:page_title, "Ver Vehículo #{vehicle.plate}")
     |> assign(:vehicle, vehicle)}
  end
end
