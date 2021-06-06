defmodule CarWorkshop.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string, null: false
      add :price, :float, null: false, default: 0.0
      add :is_deleted, :boolean, null: false, default: false

      timestamps()
    end

  end
end
