defmodule CarWorkshopWeb.VehicleLive.Index do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Vehicles
  alias CarWorkshop.{Vehicles.Vehicle, Accounts.Customer}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, view_to_show: :vehicle_view)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("set-photos-ids", %{"photos_ids" => photos_ids}, socket) do
    photos_urls =
      photos_ids
      |> String.split(",")
      |> Enum.map(fn id -> "https://drive.google.com/uc?id=#{id}" end)

    {:noreply, assign(socket, photos_urls: photos_urls, view_to_show: :customer_view)}
  end

  @impl true
  def handle_info(
        {:vehicle_registered, vehicle, :no_photos_uploaded},
        %{assigns: %{live_action: :new}} = socket
      ),
      do:
        {:noreply,
         assign(socket, vehicle: vehicle, photos_urls: [], view_to_show: :customer_view)}

  @impl true
  def handle_info({:vehicle_registered, vehicle, :no_photos_uploaded}, socket),
    do: {:noreply, assign(socket, vehicle: vehicle, view_to_show: :customer_view)}

  @impl true
  def handle_info({:vehicle_registered, vehicle, _}, socket),
    do: {:noreply, assign(socket, vehicle: vehicle, view_to_show: :vehicle_view)}

  @impl true
  def handle_info({:customer_registered, customer, :existing}, socket),
    do: {:noreply, assign(socket, customer: customer, view_to_show: :customer_view)}

  @impl true
  def handle_info({:customer_registered, customer, :saved}, socket) do
    {:ok, vehicle} =
      Vehicles.update_vehicle(socket.assigns.vehicle, %{
        "photos" => socket.assigns.photos_urls,
        "customer_id" => customer.id
      })

    {:noreply,
     push_redirect(socket,
       to: Routes.vehicle_show_path(socket, :show, vehicle)
     )}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Vehículo")
    |> assign(:vehicle, Vehicles.get_vehicle!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Registrar Vehículo")
    |> assign(:vehicle, %Vehicle{})
    |> assign(:customer, %Customer{})
  end
end
