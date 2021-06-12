defmodule CarWorkshop.Repo.Migrations.AddCostToWorkOrderServices do
  use Ecto.Migration

  def up do
    alter table(:work_order_services) do
      add :cost, :float, null: false, default: 0.0
    end
  end

  def down do
    alter table(:work_order_services) do
      remove :cost, :float
    end
  end
end
