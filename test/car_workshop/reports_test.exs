defmodule CarWorkshop.ReportsTest do
  use CarWorkshop.DataCase

  alias CarWorkshop.Reports

  describe "reports" do
    alias CarWorkshop.Reports.Report

    @valid_attrs %{brand: "some brand", chassis: "some chassis", class: "some class", color: "some color", customer_identity_number: 42, fuel_type: "some fuel_type", guarantee_months: 42, km: 42, model: "some model", notes: "some notes", plate: "some plate"}
    @update_attrs %{brand: "some updated brand", chassis: "some updated chassis", class: "some updated class", color: "some updated color", customer_identity_number: 43, fuel_type: "some updated fuel_type", guarantee_months: 43, km: 43, model: "some updated model", notes: "some updated notes", plate: "some updated plate"}
    @invalid_attrs %{brand: nil, chassis: nil, class: nil, color: nil, customer_identity_number: nil, fuel_type: nil, guarantee_months: nil, km: nil, model: nil, notes: nil, plate: nil}

    def report_fixture(attrs \\ %{}) do
      {:ok, report} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reports.create_report()

      report
    end

    test "list_reports/0 returns all reports" do
      report = report_fixture()
      assert Reports.list_reports() == [report]
    end

    test "get_report!/1 returns the report with given id" do
      report = report_fixture()
      assert Reports.get_report!(report.id) == report
    end

    test "create_report/1 with valid data creates a report" do
      assert {:ok, %Report{} = report} = Reports.create_report(@valid_attrs)
      assert report.brand == "some brand"
      assert report.chassis == "some chassis"
      assert report.class == "some class"
      assert report.color == "some color"
      assert report.customer_identity_number == 42
      assert report.fuel_type == "some fuel_type"
      assert report.guarantee_months == 42
      assert report.km == 42
      assert report.model == "some model"
      assert report.notes == "some notes"
      assert report.plate == "some plate"
    end

    test "create_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reports.create_report(@invalid_attrs)
    end

    test "update_report/2 with valid data updates the report" do
      report = report_fixture()
      assert {:ok, %Report{} = report} = Reports.update_report(report, @update_attrs)
      assert report.brand == "some updated brand"
      assert report.chassis == "some updated chassis"
      assert report.class == "some updated class"
      assert report.color == "some updated color"
      assert report.customer_identity_number == 43
      assert report.fuel_type == "some updated fuel_type"
      assert report.guarantee_months == 43
      assert report.km == 43
      assert report.model == "some updated model"
      assert report.notes == "some updated notes"
      assert report.plate == "some updated plate"
    end

    test "update_report/2 with invalid data returns error changeset" do
      report = report_fixture()
      assert {:error, %Ecto.Changeset{}} = Reports.update_report(report, @invalid_attrs)
      assert report == Reports.get_report!(report.id)
    end

    test "delete_report/1 deletes the report" do
      report = report_fixture()
      assert {:ok, %Report{}} = Reports.delete_report(report)
      assert_raise Ecto.NoResultsError, fn -> Reports.get_report!(report.id) end
    end

    test "change_report/1 returns a report changeset" do
      report = report_fixture()
      assert %Ecto.Changeset{} = Reports.change_report(report)
    end
  end
end
