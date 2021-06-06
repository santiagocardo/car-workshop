defmodule CarWorkshop.Repo.Migrations.CreateWorkOrders do
  use Ecto.Migration

  def change do
    create table(:work_orders) do
      add :plate, :string, null: false
      add :mechanic, :string, null: false

      timestamps()
    end

    create unique_index(:work_orders, [:plate])
  end
end
