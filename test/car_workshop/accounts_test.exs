defmodule CarWorkshop.AccountsTest do
  use CarWorkshop.DataCase

  alias CarWorkshop.Accounts

  describe "customers" do
    alias CarWorkshop.Accounts.Customer

    @valid_attrs %{address: "some address", city: "some city", email: "some email", identity_number: 42, name: "some name", phone: "some phone"}
    @update_attrs %{address: "some updated address", city: "some updated city", email: "some updated email", identity_number: 43, name: "some updated name", phone: "some updated phone"}
    @invalid_attrs %{address: nil, city: nil, email: nil, identity_number: nil, name: nil, phone: nil}

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_customer()

      customer
    end

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Accounts.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Accounts.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = Accounts.create_customer(@valid_attrs)
      assert customer.address == "some address"
      assert customer.city == "some city"
      assert customer.email == "some email"
      assert customer.identity_number == 42
      assert customer.name == "some name"
      assert customer.phone == "some phone"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Accounts.update_customer(customer, @update_attrs)
      assert customer.address == "some updated address"
      assert customer.city == "some updated city"
      assert customer.email == "some updated email"
      assert customer.identity_number == 43
      assert customer.name == "some updated name"
      assert customer.phone == "some updated phone"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_customer(customer, @invalid_attrs)
      assert customer == Accounts.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Accounts.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Accounts.change_customer(customer)
    end
  end
end
