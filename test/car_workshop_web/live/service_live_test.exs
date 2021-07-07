defmodule CarWorkshopWeb.ServiceLiveTest do
  use CarWorkshopWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @create_attrs %{name: "some service", price: 10.0}
  @update_attrs %{name: "some updated service", price: 20.0}
  @invalid_attrs %{name: nil, price: nil}

  describe "Index" do
    setup %{conn: conn} do
      conn = assign(conn, :current_user, create_user())

      {:ok, conn: conn, service: insert_service()}
    end

    test "lists all services", %{conn: conn, service: service} do
      {:ok, _index_live, html} = live(conn, Routes.service_index_path(conn, :index))

      assert html =~ "Servicios y Procedimientos"
      assert html =~ service.name
    end

    test "saves new service", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.service_index_path(conn, :index))

      assert index_live
             |> element("a", "Crear")
             |> render_click() =~ "Crear"

      assert_patch(index_live, Routes.service_index_path(conn, :new))

      assert index_live
             |> form("#service-form", service: @invalid_attrs)
             |> render_change() =~ "no puede estar en blanco"

      {:ok, _, html} =
        index_live
        |> form("#service-form", service: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.service_index_path(conn, :index))

      assert html =~ "some service"
    end

    test "updates service in listing", %{conn: conn, service: service} do
      {:ok, index_live, _html} = live(conn, Routes.service_index_path(conn, :index))

      assert index_live
             |> element("#service-#{service.id} a", "Editar")
             |> render_click() =~ "Editar Servicio ##{service.id}"

      assert_patch(index_live, Routes.service_index_path(conn, :edit, service))

      assert index_live
             |> form("#service-form", service: @invalid_attrs)
             |> render_change() =~ "no puede estar en blanco"

      {:ok, _, html} =
        index_live
        |> form("#service-form", service: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.service_index_path(conn, :index))

      assert html =~ "some updated service"
    end

    test "deletes service in listing", %{conn: conn, service: service} do
      {:ok, index_live, _html} = live(conn, Routes.service_index_path(conn, :index))

      assert index_live
             |> element("#service-#{service.id} a", "Eliminar")
             |> render_click()

      refute has_element?(index_live, "#service-#{service.id}")
    end
  end
end
