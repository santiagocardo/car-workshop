defmodule CarWorkshopWeb.WorkOrderLiveTest do
  use CarWorkshopWeb.ConnCase

  import Phoenix.LiveViewTest

  alias CarWorkshop.WorkOrders

  @create_attrs %{mechanic: "some mechanic", plate: "some plate"}
  @update_attrs %{mechanic: "some updated mechanic", plate: "some updated plate"}
  @invalid_attrs %{mechanic: nil, plate: nil}

  defp fixture(:work_order) do
    {:ok, work_order} = WorkOrders.create_work_order(@create_attrs)
    work_order
  end

  defp create_work_order(_) do
    work_order = fixture(:work_order)
    %{work_order: work_order}
  end

  describe "Index" do
    setup [:create_work_order]

    test "lists all work_orders", %{conn: conn, work_order: work_order} do
      {:ok, _index_live, html} = live(conn, Routes.work_order_index_path(conn, :index))

      assert html =~ "Listing Work orders"
      assert html =~ work_order.mechanic
    end

    test "saves new work_order", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.work_order_index_path(conn, :index))

      assert index_live |> element("a", "New Work order") |> render_click() =~
               "New Work order"

      assert_patch(index_live, Routes.work_order_index_path(conn, :new))

      assert index_live
             |> form("#work_order-form", work_order: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#work_order-form", work_order: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.work_order_index_path(conn, :index))

      assert html =~ "Work order created successfully"
      assert html =~ "some mechanic"
    end

    test "updates work_order in listing", %{conn: conn, work_order: work_order} do
      {:ok, index_live, _html} = live(conn, Routes.work_order_index_path(conn, :index))

      assert index_live |> element("#work_order-#{work_order.id} a", "Edit") |> render_click() =~
               "Edit Work order"

      assert_patch(index_live, Routes.work_order_index_path(conn, :edit, work_order))

      assert index_live
             |> form("#work_order-form", work_order: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#work_order-form", work_order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.work_order_index_path(conn, :index))

      assert html =~ "Work order updated successfully"
      assert html =~ "some updated mechanic"
    end

    test "deletes work_order in listing", %{conn: conn, work_order: work_order} do
      {:ok, index_live, _html} = live(conn, Routes.work_order_index_path(conn, :index))

      assert index_live |> element("#work_order-#{work_order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#work_order-#{work_order.id}")
    end
  end

  describe "Show" do
    setup [:create_work_order]

    test "displays work_order", %{conn: conn, work_order: work_order} do
      {:ok, _show_live, html} = live(conn, Routes.work_order_show_path(conn, :show, work_order))

      assert html =~ "Show Work order"
      assert html =~ work_order.mechanic
    end

    test "updates work_order within modal", %{conn: conn, work_order: work_order} do
      {:ok, show_live, _html} = live(conn, Routes.work_order_show_path(conn, :show, work_order))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Work order"

      assert_patch(show_live, Routes.work_order_show_path(conn, :edit, work_order))

      assert show_live
             |> form("#work_order-form", work_order: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#work_order-form", work_order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.work_order_show_path(conn, :show, work_order))

      assert html =~ "Work order updated successfully"
      assert html =~ "some updated mechanic"
    end
  end
end
