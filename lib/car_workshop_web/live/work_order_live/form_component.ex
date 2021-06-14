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
    work_order_params = Map.update!(work_order_params, "plate", &String.upcase/1)

    case Vehicles.get_vehicle_by_plate(work_order_params["plate"]) do
      nil ->
        error_response(socket, "este vehículo no está registrado")

      _vehicle ->
        maybe_validate_and_save_work_order(socket, socket.assigns.action, work_order_params)
    end
  end

  defp maybe_validate_and_save_work_order(socket, :edit, work_order_params) do
    work_order_params =
      map_services(
        work_order_params,
        socket.assigns.work_order.work_order_services
      )

    save_work_order(socket, :edit, work_order_params)
  end

  defp maybe_validate_and_save_work_order(socket, :new, work_order_params) do
    case WorkOrders.get_work_order_by_plate(work_order_params["plate"]) do
      %WorkOrders.WorkOrder{is_completed: false} ->
        error_response(socket, "ya hay una orden en proceso para este vehículo")

      _ ->
        work_order_params =
          map_services(
            work_order_params,
            socket.assigns.work_order.work_order_services
          )

        save_work_order(socket, :new, work_order_params)
    end
  end

  defp save_work_order(socket, :edit, work_order_params) do
    case WorkOrders.update_work_order(socket.assigns.work_order, work_order_params) do
      {:ok, _work_order} ->
        {:noreply, push_redirect(socket, to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_work_order(socket, :new, work_order_params) do
    case WorkOrders.create_work_order(work_order_params) do
      {:ok, _work_order} ->
        {:noreply, push_redirect(socket, to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp map_services(work_order_params, services) do
    price_list = Enum.map(services, &%{id: &1.id, price: &1.price})

    work_order_services =
      work_order_params["work_order_services"]
      |> Map.values()
      |> Enum.filter(&(&1["checked"] == "true" and &1["qty"] != ""))
      |> Enum.map(fn ser ->
        service_id = String.to_integer(ser["id"])
        %{price: price} = Enum.find(price_list, &(&1.id == service_id))

        %{
          service_id: service_id,
          qty: String.to_integer(ser["qty"]),
          cost: price
        }
      end)

    Map.put(work_order_params, "work_order_services", work_order_services)
  end

  defp error_response(socket, error_message) do
    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.add_error(:plate, error_message)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
end
