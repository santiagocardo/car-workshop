defmodule CarWorkshop.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :plate, :string, null: false
      add :brand, :string, null: false
      add :model, :string, null: false
      add :color, :string, null: false
      add :class, :string, null: false
      add :km, :integer, null: false
      add :fuel_type, :string, null: false
      add :chassis, :string
      add :notes, :text
      add :photos, {:array, :string}, null: false, default: []
      add :customer_id, references(:customers, on_delete: :nothing)

      timestamps()
    end

    create index(:vehicles, [:customer_id])
    create unique_index(:vehicles, [:plate])
  end
end
