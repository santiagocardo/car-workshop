defmodule CarWorkshopWeb.TestHelpers do
  alias CarWorkshop.{
    Accounts,
    Vehicles,
    Services,
    WorkOrders,
    Reports
  }

  def create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(default_user())
      |> Accounts.create_user()

    user
  end

  def register_customer(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(default_customer())
      |> Accounts.register_customer()

    customer
  end

  def register_vehicle(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> Enum.into(default_vehicle())
      |> Vehicles.register_vehicle()

    vehicle
  end

  def insert_service(attrs \\ %{}) do
    {:ok, service} =
      attrs
      |> Enum.into(default_service())
      |> Services.create_service()

    service
  end

  def insert_work_order(attrs \\ %{}) do
    {:ok, work_order} =
      attrs
      |> Enum.into(default_work_order())
      |> WorkOrders.create_work_order()

    work_order
  end

  def insert_report(attrs \\ %{}) do
    {:ok, report} =
      attrs
      |> Enum.into(default_report())
      |> Reports.create_report()

    report
  end

  defp default_user() do
    %{username: "santiagocardo", name: "Santiago Cardona", password: "some password"}
  end

  defp default_customer() do
    %{
      name: "Some User",
      identity_number: 9_999_999,
      phone: "1234567890",
      email: "me@test.com",
      address: "any address",
      city: "any city"
    }
  end

  defp default_vehicle() do
    %{
      brand: "some brand",
      chassis: "some chassis",
      class: "car",
      color: "some color",
      fuel_type: "gas",
      guarantee_months: 42,
      km: 42,
      model: "some model",
      notes: "some notes",
      plate: "BMA809"
    }
  end

  defp default_service() do
    %{name: "some service", price: 10.0, is_deleted: false}
  end

  defp default_work_order() do
    %{mechanic: "some mechanic", plate: "BMA809", is_completed: false}
  end

  defp default_report() do
    default_vehicle()
    |> Map.put(:customer_identity_number, 9_999_999)
  end
end
