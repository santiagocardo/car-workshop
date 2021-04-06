defmodule CarWorkshop.VehiclesTest do
  use CarWorkshop.DataCase

  alias CarWorkshop.Vehicles

  describe "vehicles" do
    alias CarWorkshop.Vehicles.Vehicle

    @valid_attrs %{brand: "some brand", chassis: "some chassis", class: "some class", color: "some color", fuel_type: "some fuel_type", km: 42, model: "some model", notes: "some notes", photos: [], plate: "some plate"}
    @update_attrs %{brand: "some updated brand", chassis: "some updated chassis", class: "some updated class", color: "some updated color", fuel_type: "some updated fuel_type", km: 43, model: "some updated model", notes: "some updated notes", photos: [], plate: "some updated plate"}
    @invalid_attrs %{brand: nil, chassis: nil, class: nil, color: nil, fuel_type: nil, km: nil, model: nil, notes: nil, photos: nil, plate: nil}

    def vehicle_fixture(attrs \\ %{}) do
      {:ok, vehicle} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vehicles.create_vehicle()

      vehicle
    end

    test "list_vehicles/0 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert Vehicles.list_vehicles() == [vehicle]
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Vehicles.get_vehicle!(vehicle.id) == vehicle
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
      assert {:ok, %Vehicle{} = vehicle} = Vehicles.create_vehicle(@valid_attrs)
      assert vehicle.brand == "some brand"
      assert vehicle.chassis == "some chassis"
      assert vehicle.class == "some class"
      assert vehicle.color == "some color"
      assert vehicle.fuel_type == "some fuel_type"
      assert vehicle.km == 42
      assert vehicle.model == "some model"
      assert vehicle.notes == "some notes"
      assert vehicle.photos == []
      assert vehicle.plate == "some plate"
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicles.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{} = vehicle} = Vehicles.update_vehicle(vehicle, @update_attrs)
      assert vehicle.brand == "some updated brand"
      assert vehicle.chassis == "some updated chassis"
      assert vehicle.class == "some updated class"
      assert vehicle.color == "some updated color"
      assert vehicle.fuel_type == "some updated fuel_type"
      assert vehicle.km == 43
      assert vehicle.model == "some updated model"
      assert vehicle.notes == "some updated notes"
      assert vehicle.photos == []
      assert vehicle.plate == "some updated plate"
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Vehicles.get_vehicle!(vehicle.id)
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Vehicles.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Vehicles.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Vehicles.change_vehicle(vehicle)
    end
  end
end
