defmodule CarWorkshop.WorkOrdersTest do
  use CarWorkshop.DataCase

  alias CarWorkshop.WorkOrders

  describe "work_orders" do
    alias CarWorkshop.WorkOrders.WorkOrder

    @valid_attrs %{mechanic: "some mechanic", plate: "some plate"}
    @update_attrs %{mechanic: "some updated mechanic", plate: "some updated plate"}
    @invalid_attrs %{mechanic: nil, plate: nil}

    def work_order_fixture(attrs \\ %{}) do
      {:ok, work_order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkOrders.create_work_order()

      work_order
    end

    test "list_work_orders/0 returns all work_orders" do
      work_order = work_order_fixture()
      assert WorkOrders.list_work_orders() == [work_order]
    end

    test "get_work_order!/1 returns the work_order with given id" do
      work_order = work_order_fixture()
      assert WorkOrders.get_work_order!(work_order.id) == work_order
    end

    test "create_work_order/1 with valid data creates a work_order" do
      assert {:ok, %WorkOrder{} = work_order} = WorkOrders.create_work_order(@valid_attrs)
      assert work_order.mechanic == "some mechanic"
      assert work_order.plate == "some plate"
    end

    test "create_work_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkOrders.create_work_order(@invalid_attrs)
    end

    test "update_work_order/2 with valid data updates the work_order" do
      work_order = work_order_fixture()
      assert {:ok, %WorkOrder{} = work_order} = WorkOrders.update_work_order(work_order, @update_attrs)
      assert work_order.mechanic == "some updated mechanic"
      assert work_order.plate == "some updated plate"
    end

    test "update_work_order/2 with invalid data returns error changeset" do
      work_order = work_order_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkOrders.update_work_order(work_order, @invalid_attrs)
      assert work_order == WorkOrders.get_work_order!(work_order.id)
    end

    test "delete_work_order/1 deletes the work_order" do
      work_order = work_order_fixture()
      assert {:ok, %WorkOrder{}} = WorkOrders.delete_work_order(work_order)
      assert_raise Ecto.NoResultsError, fn -> WorkOrders.get_work_order!(work_order.id) end
    end

    test "change_work_order/1 returns a work_order changeset" do
      work_order = work_order_fixture()
      assert %Ecto.Changeset{} = WorkOrders.change_work_order(work_order)
    end
  end
end
