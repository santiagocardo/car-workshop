defmodule CarWorkshopWeb.WorkOrderLive.Show do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.{
    WorkOrders,
    Services,
    Reports,
    Vehicles
  }

  @impl true
  def mount(_params, _session, socket) do
    changeset = Reports.change_report(%Reports.Report{})

    {:ok, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    work_order = WorkOrders.get_work_order!(id)
    vehicle = Vehicles.get_vehicle_by_plate(work_order.plate)

    socket =
      socket
      |> assign(:work_order, work_order)
      |> assign(:current_services, work_order.work_order_services)
      |> assign(:vehicle, vehicle)

    {:noreply, apply_action(socket, socket.assigns.live_action, %{"id" => id})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Órden de Trabajo ##{id}")
  end

  defp apply_action(socket, action, %{"id" => id}) when action in [:edit, :complete] do
    case socket.assigns.work_order do
      %WorkOrders.WorkOrder{is_completed: true} ->
        push_redirect(socket, to: Routes.work_order_show_path(socket, :show, id))

      work_order ->
        update_work_order(socket, action, work_order)
    end
  end

  defp update_work_order(socket, :edit, work_order) do
    current_services =
      work_order.work_order_services
      |> Enum.map(&Map.merge(&1.service, %{qty: &1.qty, checked: true}))

    services_to_show =
      Services.list_services()
      |> Enum.map(fn s -> Enum.find(current_services, s, &(&1.id == s.id)) end)

    work_order = Map.put(work_order, :work_order_services, services_to_show)

    socket
    |> assign(:page_title, "Editar Órden de Trabajo ##{work_order.id}")
    |> assign(:work_order, work_order)
  end

  defp update_work_order(socket, :complete, work_order) do
    socket
    |> assign(:page_title, "Completar Órden de Trabajo ##{work_order.id}")
  end

  @impl true
  def handle_event("save", %{"report" => %{"guarantee_months" => months}}, socket) do
    vehicle = Vehicles.get_vehicle_by_plate(socket.assigns.work_order.plate)

    new_report =
      vehicle
      |> Map.drop([:__meta__, :__struct__])
      |> Map.merge(%{
        guarantee_months: months,
        customer_identity_number: vehicle.customer.identity_number,
        customer_id: vehicle.customer_id,
        work_order_id: socket.assigns.work_order.id
      })

    case Reports.create_report(new_report) do
      {:ok, report} ->
        {:ok, _work_order} =
          WorkOrders.update_work_order(socket.assigns.work_order, %{is_completed: true})

        {:noreply, push_redirect(socket, to: Routes.report_show_path(socket, :show, report))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
