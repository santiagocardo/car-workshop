defmodule CarWorkshopWeb.VehicleLive.Index do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Vehicles
  alias CarWorkshop.{Vehicles.Vehicle, Accounts.Customer}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, customer: %Customer{}, view_to_show: :customer_view)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("set-photos-ids", %{"photos_ids" => photos_ids}, socket) do
    photos_ids = String.split(photos_ids, ",")
    put_photos_ids(photos_ids, socket)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:vehicle, Vehicles.get_vehicle!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:vehicle, %Vehicle{})
    |> assign(:customer, %Customer{})
  end

  @impl true
  def handle_info({:customer_registered, customer, view_to_show}, socket),
    do: {:noreply, assign(socket, customer: customer, view_to_show: view_to_show)}

  @impl true
  def handle_info({:vehicle_registered, vehicle, photos_uploaded?}, socket)
      when photos_uploaded? == true,
      do: {:noreply, assign(socket, vehicle: vehicle, view_to_show: :vehicle_view)}

  @impl true
  def handle_info(
        {:vehicle_registered, _vehicle, false},
        %{assigns: %{live_action: :new}} = socket
      ),
      do: put_photos_ids([], socket)

  @impl true
  def handle_info({:vehicle_registered, vehicle, false}, socket),
    do: {:noreply, push_redirect(socket, to: Routes.vehicle_show_path(socket, :show, vehicle))}

  defp put_photos_ids(photos_ids, socket) do
    {:ok, vehicle} = Vehicles.update_vehicle(socket.assigns.vehicle, %{"photos" => photos_ids})

    {:noreply, push_redirect(socket, to: Routes.vehicle_show_path(socket, :show, vehicle))}
  end
end
