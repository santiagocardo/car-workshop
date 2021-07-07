defmodule CarWorkshopWeb.ReportLiveTest do
  use CarWorkshopWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    service = insert_service()
    customer = register_customer()
    vehicle = register_vehicle(%{customer_id: customer.id})

    work_order =
      insert_work_order(%{
        plate: vehicle.plate,
        work_order_services: [
          %{service_id: service.id, qty: 2, cost: 10.0}
        ]
      })

    report = insert_report(%{work_order_id: work_order.id, customer_id: customer.id})

    conn = assign(conn, :current_user, create_user())

    {:ok, conn: conn, report: report}
  end

  describe "Index" do
    test "lists all reports", %{conn: conn, report: report} do
      {:ok, _index_live, html} = live(conn, Routes.report_index_path(conn, :index))

      assert html =~ "Reportes Encontrados"
      assert html =~ report.plate
    end

    test "search reports in listing", %{conn: conn, report: report} do
      {:ok, index_live, _html} = live(conn, Routes.report_index_path(conn, :index))

      assert index_live
             |> form("#reports-search-form", report: %{plate: report.plate})
             |> render_submit() =~ report.plate

      assert index_live
             |> form("#reports-search-form", report: %{brand: report.brand})
             |> render_submit() =~ "#{report.brand} #{report.model} #{report.color}"
    end

    test "deletes report in listing", %{conn: conn, report: report} do
      {:ok, index_live, _html} = live(conn, Routes.report_index_path(conn, :index))

      assert index_live |> element("#report-#{report.id} a", "Eliminar") |> render_click()
      refute has_element?(index_live, "#report-#{report.id}")
    end
  end

  describe "Show" do
    test "displays report", %{conn: conn, report: report} do
      {:ok, _show_live, html} = live(conn, Routes.report_show_path(conn, :show, report))

      assert html =~ "Reporte ##{report.id}"
      assert html =~ report.plate
    end
  end
end
