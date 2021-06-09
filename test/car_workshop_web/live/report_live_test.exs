defmodule CarWorkshopWeb.ReportLiveTest do
  use CarWorkshopWeb.ConnCase

  import Phoenix.LiveViewTest

  alias CarWorkshop.Reports

  @create_attrs %{brand: "some brand", chassis: "some chassis", class: "some class", color: "some color", customer_identity_number: 42, fuel_type: "some fuel_type", guarantee_months: 42, km: 42, model: "some model", notes: "some notes", plate: "some plate"}
  @update_attrs %{brand: "some updated brand", chassis: "some updated chassis", class: "some updated class", color: "some updated color", customer_identity_number: 43, fuel_type: "some updated fuel_type", guarantee_months: 43, km: 43, model: "some updated model", notes: "some updated notes", plate: "some updated plate"}
  @invalid_attrs %{brand: nil, chassis: nil, class: nil, color: nil, customer_identity_number: nil, fuel_type: nil, guarantee_months: nil, km: nil, model: nil, notes: nil, plate: nil}

  defp fixture(:report) do
    {:ok, report} = Reports.create_report(@create_attrs)
    report
  end

  defp create_report(_) do
    report = fixture(:report)
    %{report: report}
  end

  describe "Index" do
    setup [:create_report]

    test "lists all reports", %{conn: conn, report: report} do
      {:ok, _index_live, html} = live(conn, Routes.report_index_path(conn, :index))

      assert html =~ "Listing Reports"
      assert html =~ report.brand
    end

    test "saves new report", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.report_index_path(conn, :index))

      assert index_live |> element("a", "New Report") |> render_click() =~
               "New Report"

      assert_patch(index_live, Routes.report_index_path(conn, :new))

      assert index_live
             |> form("#report-form", report: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#report-form", report: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.report_index_path(conn, :index))

      assert html =~ "Report created successfully"
      assert html =~ "some brand"
    end

    test "updates report in listing", %{conn: conn, report: report} do
      {:ok, index_live, _html} = live(conn, Routes.report_index_path(conn, :index))

      assert index_live |> element("#report-#{report.id} a", "Edit") |> render_click() =~
               "Edit Report"

      assert_patch(index_live, Routes.report_index_path(conn, :edit, report))

      assert index_live
             |> form("#report-form", report: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#report-form", report: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.report_index_path(conn, :index))

      assert html =~ "Report updated successfully"
      assert html =~ "some updated brand"
    end

    test "deletes report in listing", %{conn: conn, report: report} do
      {:ok, index_live, _html} = live(conn, Routes.report_index_path(conn, :index))

      assert index_live |> element("#report-#{report.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#report-#{report.id}")
    end
  end

  describe "Show" do
    setup [:create_report]

    test "displays report", %{conn: conn, report: report} do
      {:ok, _show_live, html} = live(conn, Routes.report_show_path(conn, :show, report))

      assert html =~ "Show Report"
      assert html =~ report.brand
    end

    test "updates report within modal", %{conn: conn, report: report} do
      {:ok, show_live, _html} = live(conn, Routes.report_show_path(conn, :show, report))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Report"

      assert_patch(show_live, Routes.report_show_path(conn, :edit, report))

      assert show_live
             |> form("#report-form", report: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#report-form", report: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.report_show_path(conn, :show, report))

      assert html =~ "Report updated successfully"
      assert html =~ "some updated brand"
    end
  end
end
