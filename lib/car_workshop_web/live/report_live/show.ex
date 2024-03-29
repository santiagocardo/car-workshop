defmodule CarWorkshopWeb.ReportLive.Show do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Reports

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    report = Reports.get_report!(id)

    total =
      report.work_order.work_order_services
      |> Enum.reduce(0, &(&1.qty * &1.cost + &2))

    {:noreply,
     socket
     |> assign(:page_title, "Ver Reporte ##{id}")
     |> assign(:report, report)
     |> assign(:total, total)}
  end
end
