defmodule CarWorkshopWeb.WorkOrderLive.Show do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.WorkOrders
  alias CarWorkshop.Services

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    work_order = WorkOrders.get_work_order!(id)

    socket
    |> assign(:page_title, "Órden de Trabajo ##{id}")
    |> assign(:work_order, work_order)
    |> assign(:current_services, work_order.work_order_services)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    work_order = WorkOrders.get_work_order!(id)

    current_services =
      work_order.work_order_services
      |> Enum.map(&Map.merge(&1.service, %{qty: &1.qty, checked: true}))

    services_to_show =
      Services.list_services()
      |> Enum.map(fn s -> Enum.find(current_services, s, &(&1.id == s.id)) end)

    socket
    |> assign(:page_title, "Editar Órden de Trabajo ##{id}")
    |> assign(:current_services, work_order.work_order_services)
    |> assign(:work_order, Map.put(work_order, :work_order_services, services_to_show))
  end
end
