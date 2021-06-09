defmodule CarWorkshop.Reports.Report do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reports" do
    field :plate, :string
    field :brand, :string
    field :model, :string
    field :chassis, :string
    field :class, :string
    field :color, :string
    field :customer_identity_number, :integer
    field :fuel_type, :string
    field :guarantee_months, :integer
    field :km, :integer
    field :notes, :string
    field :photos, {:array, :string}, default: []

    belongs_to :customer, CarWorkshop.Accounts.Customer
    belongs_to :work_order, CarWorkshop.WorkOrders.WorkOrder

    timestamps()
  end

  @doc false
  def changeset(report, attrs) do
    report
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
      :customer_identity_number,
      :guarantee_months,
      :photos,
      :customer_id,
      :work_order_id
    ])
    |> validate_required([
      :plate,
      :brand,
      :model,
      :color,
      :class,
      :km,
      :fuel_type,
      :notes,
      :customer_identity_number,
      :guarantee_months,
      :customer_id,
      :work_order_id
    ])
    |> validate_length(:plate, min: 6, max: 6)
    |> validate_number(:km, greater_than: 0)
    |> validate_number(:customer_identity_number, greater_than: 10)
    |> validate_number(:guarantee_months, greater_than: 0)
  end
end
