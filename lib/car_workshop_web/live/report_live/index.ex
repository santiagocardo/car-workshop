defmodule CarWorkshopWeb.ReportLive.Index do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Reports
  alias CarWorkshop.Reports.Report

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :reports, list_reports())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Reportes")
    |> assign(:report, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    report = Reports.get_report!(id)
    {:ok, _} = Reports.delete_report(report)

    {:noreply, assign(socket, :reports, list_reports())}
  end

  defp list_reports do
    Reports.list_reports()
  end
end
