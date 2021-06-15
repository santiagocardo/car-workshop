defmodule CarWorkshopWeb.ReportLive.Index do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Reports
  alias CarWorkshop.Reports.Report

  @impl true
  def mount(_params, _session, socket) do
    changeset = Reports.change_report(%Report{})

    {:ok,
     assign(socket,
       changeset: changeset,
       reports: list_reports(),
       report_params: %{},
       page: 1
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Reportes")
  end

  @impl true
  def handle_event("search", %{"report" => report_params}, socket) do
    reports = find_reports(report_params, 1)

    {:noreply, assign(socket, reports: reports, report_params: report_params, page: 1)}
  end

  @impl true
  def handle_event("page-search", %{"page" => page}, socket) do
    page = String.to_integer(page)
    reports = find_reports(socket.assigns.report_params, page)

    {:noreply, assign(socket, reports: reports, page: page)}
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

  defp find_reports(%{"date" => date, "mechanic" => mechanic} = report_params, page) do
    report_params
    |> Map.drop(["date", "mechanic"])
    |> Map.to_list()
    |> Enum.filter(fn {_key, value} -> value != "" end)
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
    |> Reports.find_reports(date, mechanic, page)
  end

  defp find_reports(_, page), do: Reports.find_reports([], "", "", page)
end
