defmodule CarWorkshopWeb.WorkOrderLive.Index do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.{
    Services,
    WorkOrders,
    WorkOrders.WorkOrder
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :work_orders, list_work_orders())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    with work_order = %WorkOrder{is_completed: true} <- WorkOrders.get_work_order!(id) do
      push_redirect(socket, to: Routes.work_order_show_path(socket, :show, work_order))
    else
      work_order ->
        current_services =
          work_order.work_order_services
          |> Enum.map(&Map.merge(&1.service, %{qty: &1.qty, checked: true}))

        services_to_show =
          Services.list_services()
          |> Enum.map(fn s -> Enum.find(current_services, s, &(&1.id == s.id)) end)

        socket
        |> assign(:page_title, "Editar Orden de Trabajo ##{id}")
        |> assign(:work_order, Map.put(work_order, :work_order_services, services_to_show))
    end
  end

  defp apply_action(socket, :new, params) do
    work_order =
      %WorkOrder{}
      |> Map.put(:plate, params["plate"])
      |> Map.put(:work_order_services, Services.list_services())

    socket
    |> assign(:page_title, "Nueva Orden de Trabajo")
    |> assign(:work_order, work_order)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Órdenes de Trabajo")
    |> assign(:work_order, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    work_order = WorkOrders.get_work_order!(id)
    {:ok, _} = WorkOrders.delete_work_order(work_order)

    {:noreply, assign(socket, :work_orders, list_work_orders())}
  end

  defp list_work_orders do
    WorkOrders.list_work_orders()
  end
end
