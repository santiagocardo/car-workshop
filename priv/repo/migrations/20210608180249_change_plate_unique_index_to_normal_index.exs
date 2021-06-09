defmodule CarWorkshop.Repo.Migrations.ChangePlateUniqueIndexToNormalIndex do
  use Ecto.Migration

  def up do
    drop unique_index(:work_orders, [:plate])
    create index(:work_orders, [:plate])
  end

  def down do
    drop index(:work_orders, [:plate])
    create unique_index(:work_orders, [:plate])
  end
end
