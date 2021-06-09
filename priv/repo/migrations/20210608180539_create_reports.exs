defmodule CarWorkshop.Repo.Migrations.CreateReports do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :plate, :string, null: false
      add :brand, :string, null: false
      add :model, :string, null: false
      add :color, :string, null: false
      add :class, :string, null: false
      add :km, :integer, null: false
      add :fuel_type, :string, null: false
      add :chassis, :string
      add :notes, :text
      add :customer_identity_number, :integer, null: false
      add :guarantee_months, :integer, null: false
      add :photos, {:array, :string}, null: false, default: []
      add :customer_id, references(:customers, on_delete: :nothing)
      add :work_order_id, references(:work_orders, on_delete: :nothing)

      timestamps()
    end

    create index(:reports, [:plate])
    create index(:reports, [:customer_id])
    create index(:reports, [:work_order_id])
  end
end
