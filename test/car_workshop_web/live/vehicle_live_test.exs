defmodule CarWorkshopWeb.VehicleLiveTest do
  use CarWorkshopWeb.ConnCase

  import Phoenix.LiveViewTest

  alias CarWorkshop.Vehicles

  @create_attrs %{brand: "some brand", chassis: "some chassis", class: "some class", color: "some color", fuel_type: "some fuel_type", km: 42, model: "some model", notes: "some notes", photos: [], plate: "some plate"}
  @update_attrs %{brand: "some updated brand", chassis: "some updated chassis", class: "some updated class", color: "some updated color", fuel_type: "some updated fuel_type", km: 43, model: "some updated model", notes: "some updated notes", photos: [], plate: "some updated plate"}
  @invalid_attrs %{brand: nil, chassis: nil, class: nil, color: nil, fuel_type: nil, km: nil, model: nil, notes: nil, photos: nil, plate: nil}

  defp fixture(:vehicle) do
    {:ok, vehicle} = Vehicles.create_vehicle(@create_attrs)
    vehicle
  end

  defp create_vehicle(_) do
    vehicle = fixture(:vehicle)
    %{vehicle: vehicle}
  end

  describe "Index" do
    setup [:create_vehicle]

    test "lists all vehicles", %{conn: conn, vehicle: vehicle} do
      {:ok, _index_live, html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert html =~ "Listing Vehicles"
      assert html =~ vehicle.brand
    end

    test "saves new vehicle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert index_live |> element("a", "New Vehicle") |> render_click() =~
               "New Vehicle"

      assert_patch(index_live, Routes.vehicle_index_path(conn, :new))

      assert index_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#vehicle-form", vehicle: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_index_path(conn, :index))

      assert html =~ "Vehicle created successfully"
      assert html =~ "some brand"
    end

    test "updates vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert index_live |> element("#vehicle-#{vehicle.id} a", "Edit") |> render_click() =~
               "Edit Vehicle"

      assert_patch(index_live, Routes.vehicle_index_path(conn, :edit, vehicle))

      assert index_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#vehicle-form", vehicle: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_index_path(conn, :index))

      assert html =~ "Vehicle updated successfully"
      assert html =~ "some updated brand"
    end

    test "deletes vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_index_path(conn, :index))

      assert index_live |> element("#vehicle-#{vehicle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#vehicle-#{vehicle.id}")
    end
  end

  describe "Show" do
    setup [:create_vehicle]

    test "displays vehicle", %{conn: conn, vehicle: vehicle} do
      {:ok, _show_live, html} = live(conn, Routes.vehicle_show_path(conn, :show, vehicle))

      assert html =~ "Show Vehicle"
      assert html =~ vehicle.brand
    end

    test "updates vehicle within modal", %{conn: conn, vehicle: vehicle} do
      {:ok, show_live, _html} = live(conn, Routes.vehicle_show_path(conn, :show, vehicle))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Vehicle"

      assert_patch(show_live, Routes.vehicle_show_path(conn, :edit, vehicle))

      assert show_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#vehicle-form", vehicle: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.vehicle_show_path(conn, :show, vehicle))

      assert html =~ "Vehicle updated successfully"
      assert html =~ "some updated brand"
    end
  end
end
