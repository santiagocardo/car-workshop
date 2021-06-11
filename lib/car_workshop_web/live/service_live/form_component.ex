defmodule CarWorkshopWeb.ServiceLive.FormComponent do
  use CarWorkshopWeb, :live_component

  alias CarWorkshop.Services

  @impl true
  def update(%{service: service} = assigns, socket) do
    changeset = Services.change_service(service)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"service" => service_params}, socket) do
    changeset =
      socket.assigns.service
      |> Services.change_service(service_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"service" => service_params}, socket) do
    save_work_order(socket, socket.assigns.action, service_params)
  end

  defp save_work_order(socket, :edit, service_params) do
    case Services.update_service(socket.assigns.service, service_params) do
      {:ok, _service} ->
        {:noreply, push_redirect(socket, to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_work_order(socket, :new, service_params) do
    case Services.create_service(service_params) do
      {:ok, _service} ->
        {:noreply, push_redirect(socket, to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
