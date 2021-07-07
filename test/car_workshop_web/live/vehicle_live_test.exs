defmodule CarWorkshopWeb.VehicleLiveTest do
  use CarWorkshopWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @invalid_attrs %{
    brand: nil,
    chassis: nil,
    class: "car",
    color: nil,
    fuel_type: "gas",
    km: nil,
    model: nil,
    notes: nil,
    plate: nil
  }

  setup %{conn: conn} do
    customer = register_customer()
    vehicle = register_vehicle(%{customer_id: customer.id})

    conn = assign(conn, :current_user, create_user())

    {:ok, conn: conn, vehicle: vehicle, customer: customer}
  end

  describe "Index" do
    test "render vehicle component", %{conn: conn} do
      {:ok, vehicle_live, vehicle_html} = live(conn, Routes.vehicle_index_path(conn, :new))

      assert vehicle_html =~ "Registrar Vehículo"
      assert vehicle_html =~ "Siguiente"

      assert vehicle_live
             |> form("#vehicle-form", vehicle: @invalid_attrs)
             |> render_change() =~ "no puede estar en blanco"
    end

    test "render customer component" do
      assert render_component(
               CarWorkshopWeb.CustomerComponent,
               id: :new,
               title: "Registrar Usuario",
               customer: %CarWorkshop.Accounts.Customer{}
             ) =~ "Registrar Usuario"
    end
  end

  describe "List" do
    test "lists all vehicles", %{conn: conn, vehicle: vehicle} do
      {:ok, _index_live, html} = live(conn, Routes.vehicle_list_path(conn, :index))

      assert html =~ "Vehículos Registrados"
      assert html =~ vehicle.plate
    end

    test "deletes vehicle in listing", %{conn: conn, vehicle: vehicle} do
      {:ok, index_live, _html} = live(conn, Routes.vehicle_list_path(conn, :index))

      assert index_live |> element("#vehicle-#{vehicle.id} a", "Eliminar") |> render_click()
      refute has_element?(index_live, "#vehicle-#{vehicle.id}")
    end
  end

  describe "Show" do
    test "displays vehicle", %{conn: conn, vehicle: vehicle, customer: customer} do
      {:ok, _show_live, html} = live(conn, Routes.vehicle_show_path(conn, :show, vehicle))

      assert html =~ "Vehículo: #{vehicle.brand} #{vehicle.model} #{vehicle.color}"
      assert html =~ vehicle.plate
      assert html =~ customer.name
    end
  end
end
