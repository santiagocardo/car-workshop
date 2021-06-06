defmodule CarWorkshop.Repo.Migrations.CreateWorkOrderServices do
  use Ecto.Migration

  def change do
    create table(:work_order_services, primary_key: false) do
      add :work_order_id, references(:work_orders, on_delete: :delete_all)
      add :service_id, references(:services, on_delete: :delete_all)
      add :qty, :integer, null: false, default: 0

      timestamps()
    end

    create unique_index(
      :work_order_services,
      [:work_order_id, :service_id],
      name: :work_order_id_service_id_unique_index
    )
  end
end
