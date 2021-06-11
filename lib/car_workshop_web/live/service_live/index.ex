defmodule CarWorkshopWeb.ServiceLive.Index do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Services

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :services, list_services())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar Servicio ##{id}")
    |> assign(:service, Services.get_service!(id))
  end

  defp apply_action(socket, :new, params) do
    socket
    |> assign(:page_title, "Nuevo Servicio")
    |> assign(:service, %Services.Service{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Admin Servicios y Procedimientos")
    |> assign(:service, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    service = Services.get_service!(id)

    case Services.update_service(service, %{is_deleted: true}) do
      {:ok, _service} ->
        {:noreply, assign(socket, :services, list_services())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp list_services do
    Services.list_services()
  end
end
