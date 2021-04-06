defmodule CarWorkshop.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false
      add :identity_number, :integer, null: false
      add :phone, :string, null: false
      add :email, :string, null: false
      add :address, :string, null: false
      add :city, :string, null: false

      timestamps()
    end

    create unique_index(:customers, [:email, :identity_number])
  end
end
