defmodule CarWorkshopWeb.WorkOrderLiveTest do
  use CarWorkshopWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @invalid_attrs %{mechanic: nil, plate: nil}

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

    conn = assign(conn, :current_user, create_user())

    {:ok, conn: conn, work_order: work_order, vehicle: vehicle, service: service}
  end

  describe "Index" do
    test "lists all work_orders", %{conn: conn, work_order: work_order} do
      {:ok, _index_live, html} = live(conn, Routes.work_order_index_path(conn, :index))

      assert html =~ "Órdenes de Trabajo"
      assert html =~ work_order.plate
    end

    test "saves new work_order", %{conn: conn, vehicle: vehicle, service: service} do
      new_vehicle = register_vehicle(%{plate: "BMA808", customer_id: vehicle.customer_id})

      create_attrs = %{
        "plate" => new_vehicle.plate,
        "mechanic" => "some mechanic",
        "work_order_services" => %{
          "0" => %{"id" => service.id, "checked" => "true", "qty" => 2}
        }
      }

      {:ok, index_live, _html} = live(conn, Routes.work_order_index_path(conn, :index))

      assert index_live
             |> element("a", "Crear")
             |> render_click() =~ "Nueva Orden de Trabajo"

      assert_patch(index_live, Routes.work_order_index_path(conn, :new))

      assert index_live
             |> form("#work_order-form", work_order: @invalid_attrs)
             |> render_change() =~ "no puede estar en blanco"

      {:ok, _, html} =
        index_live
        |> form("#work_order-form", work_order: create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.work_order_index_path(conn, :index))

      assert html =~ new_vehicle.plate
      assert html =~ create_attrs["mechanic"]
    end

    test "updates work_order in listing", %{conn: conn, work_order: work_order, service: service} do
      update_attrs = %{
        "plate" => work_order.plate,
        "mechanic" => "some updated mechanic",
        "work_order_services" => %{
          "0" => %{"id" => service.id, "checked" => "true", "qty" => 2}
        }
      }

      {:ok, index_live, _html} = live(conn, Routes.work_order_index_path(conn, :index))

      assert index_live
             |> element("#work-order-#{work_order.id} a", "Editar")
             |> render_click() =~ "Editar Órden de Trabajo ##{work_order.id}"

      assert_patch(index_live, Routes.work_order_index_path(conn, :edit, work_order))

      assert index_live
             |> form("#work_order-form", work_order: @invalid_attrs)
             |> render_change() =~ "no puede estar en blanco"

      {:ok, _, html} =
        index_live
        |> form("#work_order-form", work_order: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.work_order_index_path(conn, :index))

      assert html =~ work_order.plate
      assert html =~ String.upcase(update_attrs["mechanic"])
    end

    test "deletes work_order in listing", %{conn: conn, work_order: work_order} do
      {:ok, index_live, _html} = live(conn, Routes.work_order_index_path(conn, :index))

      assert index_live |> element("#work-order-#{work_order.id} a", "Eliminar") |> render_click()
      refute has_element?(index_live, "#work-order-#{work_order.id}")
    end
  end

  describe "Show" do
    test "displays work_order", %{conn: conn, work_order: work_order, vehicle: vehicle} do
      {:ok, _show_live, html} = live(conn, Routes.work_order_show_path(conn, :show, work_order))

      assert html =~ "Órden de Trabajo ##{work_order.id}"
      assert html =~ work_order.plate
      assert html =~ vehicle.model
    end

    test "updates work_order within modal", %{
      conn: conn,
      work_order: work_order,
      service: service
    } do
      update_attrs = %{
        "plate" => work_order.plate,
        "mechanic" => "some updated mechanic",
        "work_order_services" => %{
          "0" => %{"id" => service.id, "checked" => "true", "qty" => 2}
        }
      }

      {:ok, show_live, _html} = live(conn, Routes.work_order_show_path(conn, :show, work_order))

      assert show_live
             |> element("a", "Editar")
             |> render_click() =~ "Editar Órden de Trabajo ##{work_order.id}"

      assert_patch(show_live, Routes.work_order_show_path(conn, :edit, work_order))

      assert show_live
             |> form("#work_order-form", work_order: @invalid_attrs)
             |> render_change() =~ "no puede estar en blanco"

      {:ok, _, html} =
        show_live
        |> form("#work_order-form", work_order: update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.work_order_show_path(conn, :show, work_order))

      assert html =~ work_order.plate
      assert html =~ String.upcase(update_attrs["mechanic"])
    end

    test "completes work_order", %{conn: conn, work_order: work_order} do
      {:ok, show_live, html} =
        live(conn, Routes.work_order_show_path(conn, :complete, work_order))

      assert html =~ "Órden de Trabajo ##{work_order.id}"
      assert html =~ work_order.plate

      assert show_live
             |> form("#complete-work-order-form", report: %{"guarantee_months" => ""})
             |> render_submit() =~ "no puede estar en blanco"

      {:ok, _report_live, html} =
        show_live
        |> form("#complete-work-order-form", report: %{"guarantee_months" => "3"})
        |> render_submit()
        |> follow_redirect(conn)

      assert html =~ work_order.plate
      assert html =~ work_order.mechanic
      assert html =~ "Reporte"
    end
  end
end
