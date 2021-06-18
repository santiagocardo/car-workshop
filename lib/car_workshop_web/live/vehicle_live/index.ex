defmodule CarWorkshopWeb.VehicleLive.Index do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.{
    Vehicles,
    Accounts,
    Vehicles.Vehicle,
    Accounts.Customer
  }

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

    vehicle_params = Map.put(socket.assigns.vehicle_params, "photos", photos_urls)

    {:noreply, assign(socket, vehicle_params: vehicle_params, view_to_show: :customer_view)}
  end

  @impl true
  def handle_info({:vehicle, vehicle, :existing}, socket),
    do: {:noreply, assign(socket, vehicle: vehicle, view_to_show: :vehicle_view)}

  @impl true
  def handle_info({:vehicle, vehicle_params, :photos_uploaded}, socket),
    do: {:noreply, assign(socket, vehicle_params: vehicle_params, view_to_show: :vehicle_view)}

  @impl true
  def handle_info({:vehicle, vehicle_params, :no_photos_uploaded}, socket) do
    {:noreply, assign(socket, vehicle_params: vehicle_params, view_to_show: :customer_view)}
  end

  @impl true
  def handle_info({:customer, customer, :existing}, socket),
    do: {:noreply, assign(socket, customer: customer, view_to_show: :customer_view)}

  @impl true
  def handle_info({:customer, customer_params, :save}, socket) do
    case Accounts.register_customer(customer_params) do
      {:ok, customer} ->
        vehicle_params = Map.put(socket.assigns.vehicle_params, "customer_id", customer.id)

        case Vehicles.register_vehicle(vehicle_params) do
          {:ok, vehicle} ->
            {:noreply,
             push_redirect(socket, to: Routes.work_order_index_path(socket, :new, vehicle.plate))}

          {:error, _} ->
            {:noreply, push_redirect(socket, to: Routes.vehicle_index_path(socket, :new))}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp apply_action(socket, :new, params) do
    vehicle_attrs = Enum.into(params, %{}, fn {k, v} -> {String.to_atom(k), v} end)
    vehicle = Map.merge(%Vehicle{}, vehicle_attrs)

    socket
    |> assign(:page_title, "Registrar Vehículo")
    |> assign(:vehicle, vehicle)
    |> assign(:customer, %Customer{})
  end
end
