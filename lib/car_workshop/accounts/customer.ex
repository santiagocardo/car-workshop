defmodule CarWorkshop.Accounts.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :address, :string
    field :city, :string
    field :email, :string
    field :identity_number, :integer
    field :name, :string
    field :phone, :string

    has_many :vehicles, CarWorkshop.Vehicles.Vehicle
    has_many :reports, CarWorkshop.Reports.Report

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :identity_number, :phone, :email, :address, :city])
    |> validate_required([:name, :identity_number, :phone, :email, :address, :city])
    |> validate_number(:identity_number, greater_than: 10)
    |> validate_length(:name, min: 6)
    |> validate_length(:phone, min: 10, max: 10)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:address, min: 5)
    |> validate_length(:city, min: 5)
  end
end
