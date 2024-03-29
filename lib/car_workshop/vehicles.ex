defmodule CarWorkshop.Vehicles do
  @moduledoc """
  The Vehicles context.
  """

  import Ecto.Query, warn: false
  alias CarWorkshop.Repo

  alias CarWorkshop.Vehicles.Vehicle

  @doc """
  Returns the list of vehicles.

  ## Examples

      iex> list_vehicles()
      [%Vehicle{}, ...]

  """
  def list_vehicles do
    from(v in Vehicle, order_by: [desc: v.updated_at])
    |> Repo.all()
  end

  def count_vehicles, do: Repo.one(from v in Vehicle, select: fragment("count(*)"))

  @doc """
  Gets a single vehicle.

  Raises `Ecto.NoResultsError` if the Vehicle does not exist.

  ## Examples

      iex> get_vehicle!(123)
      %Vehicle{}

      iex> get_vehicle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vehicle!(id) do
    Repo.get!(Vehicle, id)
    |> Repo.preload(:customer)
  end

  def get_vehicle_by_plate(plate) do
    Vehicle
    |> Repo.get_by(plate: plate)
    |> Repo.preload(:customer)
  end

  @doc """
  Creates a vehicle.

  ## Examples

      iex> create_vehicle(%{field: value})
      {:ok, %Vehicle{}}

      iex> create_vehicle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_vehicle(attrs \\ %{}, after_save_cb \\ &{:ok, &1}) do
    plate = attrs["plate"] || ""

    vehicle =
      case get_vehicle_by_plate(plate) do
        nil ->
          %Vehicle{}
          |> Vehicle.register_changeset(attrs)
          |> Repo.insert()

        vehicle ->
          update_vehicle(vehicle, attrs)
      end

    after_save(vehicle, after_save_cb)
  end

  @doc """
  Updates a vehicle.

  ## Examples

      iex> update_vehicle(vehicle, %{field: new_value})
      {:ok, %Vehicle{}}

      iex> update_vehicle(vehicle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vehicle(%Vehicle{} = vehicle, attrs) do
    vehicle
    |> Vehicle.register_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vehicle.

  ## Examples

      iex> delete_vehicle(vehicle)
      {:ok, %Vehicle{}}

      iex> delete_vehicle(vehicle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vehicle(%Vehicle{} = vehicle) do
    Repo.delete(vehicle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicle changes.

  ## Examples

      iex> change_vehicle(vehicle)
      %Ecto.Changeset{data: %Vehicle{}}

  """
  def change_vehicle(%Vehicle{} = vehicle, attrs \\ %{}) do
    Vehicle.changeset(vehicle, attrs)
  end

  defp after_save({:ok, vehicle}, func) do
    {:ok, _vehicle} = func.(vehicle)
  end

  defp after_save(error, _func), do: error
end
