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

  describe "users" do
    alias CarWorkshop.Accounts.User

    @valid_attrs %{name: "some name", password_hash: "some password_hash", username: "some username"}
    @update_attrs %{name: "some updated name", password_hash: "some updated password_hash", username: "some updated username"}
    @invalid_attrs %{name: nil, password_hash: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "some name"
      assert user.password_hash == "some password_hash"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.name == "some updated name"
      assert user.password_hash == "some updated password_hash"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
