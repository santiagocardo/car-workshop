defmodule CarWorkshopWeb.WorkOrderLive.FormComponent do
  use CarWorkshopWeb, :live_component

  alias CarWorkshop.{WorkOrders, Vehicles}

  @impl true
  def update(%{work_order: work_order} = assigns, socket) do
    changeset = WorkOrders.change_work_order(work_order)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"work_order" => work_order_params}, socket) do
    changeset =
      socket.assigns.work_order
      |> WorkOrders.change_work_order(work_order_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"work_order" => work_order_params}, socket) do
    case Vehicles.get_vehicle_by_plate(work_order_params["plate"]) do
      nil ->
        error_response(socket, "este vehículo no está registrado")

      _vehicle ->
        maybe_validate_and_save_work_order(
          socket,
          socket.assigns.action,
          work_order_params
        )
    end
  end

  defp maybe_validate_and_save_work_order(socket, :edit, work_order_params) do
    work_order_params = map_services(work_order_params)

    save_work_order(socket, :edit, work_order_params)
  end

  defp maybe_validate_and_save_work_order(socket, :new, work_order_params) do
    case WorkOrders.get_work_order_by_plate(work_order_params["plate"]) do
      nil ->
        work_order_params = map_services(work_order_params)

        save_work_order(socket, :new, work_order_params)

      _work_order ->
        error_response(socket, "ya hay una orden en proceso para este vehículo")
    end
  end

  defp save_work_order(socket, :edit, work_order_params) do
    case WorkOrders.update_work_order(socket.assigns.work_order, work_order_params) do
      {:ok, _work_order} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_work_order(socket, :new, work_order_params) do
    case WorkOrders.create_work_order(work_order_params) do
      {:ok, _work_order} ->
        {:noreply,
         socket
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp map_services(work_order_params) do
    work_order_services =
      work_order_params["work_order_services"]
      |> Map.values()
      |> Enum.filter(&(&1["checked"] == "true" and &1["qty"] != ""))
      |> Enum.map(fn ser ->
        %{
          service_id: String.to_integer(ser["id"]),
          qty: String.to_integer(ser["qty"])
        }
      end)

    work_order_params
    |> Map.put("work_order_services", work_order_services)
  end

  defp error_response(socket, error_message) do
    {:noreply,
     assign(
       socket,
       :changeset,
       Ecto.Changeset.add_error(
         socket.assigns.changeset,
         :plate,
         error_message
       )
     )}
  end
end
