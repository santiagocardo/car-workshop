defmodule CarWorkshop.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset
  alias CarWorkshop.WorkOrders.WorkOrderService

  schema "services" do
    field :name, :string
    field :price, :float, default: 0.0
    field :is_deleted, :boolean, default: false

    has_many :work_order_services, WorkOrderService

    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:name, :price, :is_deleted])
    |> validate_required([:name])
  end
end
