defmodule CarWorkshop.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :brand, :string
    field :chassis, :string
    field :class, :string
    field :color, :string
    field :fuel_type, :string
    field :km, :integer
    field :model, :string
    field :notes, :string
    field :photos, {:array, :string}, default: []
    field :plate, :string

    belongs_to :customer, CarWorkshop.Accounts.Customer

    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [
      :plate,
      :brand,
      :model,
      :color,
      :class,
      :km,
      :fuel_type,
      :chassis,
      :notes,
      :photos,
      :customer_id
    ])
    |> validate_required([
      :plate,
      :brand,
      :model,
      :color,
      :class,
      :km,
      :fuel_type,
      :customer_id
    ])
    |> validate_length(:plate, min: 6, max: 6)
    |> validate_number(:km, greater_than: 0)
  end
end
