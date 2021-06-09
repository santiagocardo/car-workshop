defmodule CarWorkshop.Repo.Migrations.AddIsCompletedToWorkOrdersTable do
  use Ecto.Migration

  def up do
    alter table(:work_orders) do
      add :is_completed, :boolean, null: false, default: false
    end
  end

  def down do
    alter table(:work_orders) do
      remove :is_completed, :boolean
    end
  end
end
