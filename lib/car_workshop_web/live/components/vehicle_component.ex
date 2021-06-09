defmodule CarWorkshopWeb.VehicleComponent do
  use CarWorkshopWeb, :live_component

  alias CarWorkshop.{Vehicles, WorkOrders}

  @impl true
  def mount(socket) do
    {:ok,
     allow_upload(
       socket,
       :photos,
       accept: ~w(.png .jpeg .jpg),
       max_entries: 2,
       external: &presign_entry/2
     )}
  end

  @impl true
  def update(%{vehicle: vehicle} = assigns, socket) do
    changeset = Vehicles.change_vehicle(vehicle)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"vehicle" => vehicle_params}, socket) do
    plate = vehicle_params["plate"]

    validation_response = fn socket, vehicle_params ->
      {:noreply,
       assign(
         socket,
         changeset: validate_changeset(vehicle_params, socket)
       )}
    end

    if String.length(plate) == 6 do
      case Vehicles.get_vehicle_by_plate(plate) do
        nil ->
          validation_response.(socket, vehicle_params)

        vehicle ->
          send(self(), {:vehicle, vehicle, :existing})

          {:noreply, socket}
      end
    else
      validation_response.(socket, vehicle_params)
    end
  end

  @impl true
  def handle_event("save", %{"vehicle" => vehicle_params}, socket) do
    with %Ecto.Changeset{errors: []} = changeset <- validate_changeset(vehicle_params, socket) do
      case WorkOrders.get_work_order_by_plate(vehicle_params["plate"]) do
        %WorkOrders.WorkOrder{is_completed: true} ->
          register_vehicle(vehicle_params, socket)

          {:noreply, socket}

        _ ->
          changeset =
            Ecto.Changeset.add_error(
              changeset,
              :plate,
              "este vehículo tiene una orden de trabajo en proceso"
            )

          {:noreply, assign(socket, :changeset, changeset)}
      end
    else
      changeset ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  @google_drive_url "https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart"
  @google_drive_scope "https://www.googleapis.com/auth/drive.file"
  @drive_parent_id Application.fetch_env!(:car_workshop, :drive_parent_id)
  defp presign_entry(entry, socket) do
    {:ok, %{token: token}} = Goth.Token.for_scope(@google_drive_scope)

    fields = %{
      name: "#{entry.uuid}.#{ext(entry)}",
      content_type: entry.client_type,
      parent: @drive_parent_id,
      token: token
    }

    {:ok, %{uploader: "GoogleDriveMultipart", url: @google_drive_url, fields: fields}, socket}
  end

  defp register_vehicle(vehicle_params, socket) do
    {completed, _} = uploaded_entries(socket, :photos)

    if Enum.count(completed) > 0 do
      send(self(), {:vehicle, vehicle_params, :photos_uploaded})
    else
      send(self(), {:vehicle, vehicle_params, :no_photos_uploaded})
    end
  end

  defp validate_changeset(vehicle_params, socket) do
    socket.assigns.vehicle
    |> Vehicles.change_vehicle(vehicle_params)
    |> Map.put(:action, :validate)
  end
end
