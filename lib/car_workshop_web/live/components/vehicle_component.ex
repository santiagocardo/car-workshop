defmodule CarWorkshopWeb.VehicleComponent do
  use CarWorkshopWeb, :live_component

  alias CarWorkshop.Vehicles

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

    changeset =
      socket.assigns.vehicle
      |> Vehicles.change_vehicle(vehicle_params)
      |> Map.put(:action, :validate)

    if String.length(plate) == 6 do
      case Vehicles.get_vehicle_by_plate(plate) do
        nil ->
          {:noreply, assign(socket, changeset: changeset)}

        vehicle ->
          send(self(), {:vehicle_registered, vehicle, :existing})

          {:noreply, socket}
      end
    else
      {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("save", %{"vehicle" => vehicle_params}, socket) do
    case Vehicles.create_vehicle(vehicle_params) do
      {:ok, vehicle} ->
        send_registered_vehicle(vehicle, socket)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
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

  defp send_registered_vehicle(vehicle, socket) do
    {completed, _} = uploaded_entries(socket, :photos)

    if Enum.count(completed) > 0 do
      send(self(), {:vehicle_registered, vehicle, :saved})
    else
      send(self(), {:vehicle_registered, vehicle, :no_photos_uploaded})
    end
  end
end
