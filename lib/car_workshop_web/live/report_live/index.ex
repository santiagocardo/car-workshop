defmodule CarWorkshopWeb.ReportLive.Index do
  use CarWorkshopWeb, :live_view

  alias CarWorkshop.Reports
  alias CarWorkshop.Reports.Report

  @impl true
  def mount(_params, _session, socket) do
    changeset = Reports.change_report(%Report{})

    {:ok, assign(socket, reports: list_reports(), changeset: changeset)}
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
    query_opts =
      report_params
      |> Map.delete("date")
      |> Map.to_list()
      |> Enum.filter(fn {_key, value} -> value != "" end)
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> IO.inspect()

    reports = Reports.find_reports(query_opts, report_params["date"])

    {:noreply, assign(socket, :reports, reports)}
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
