defmodule CarWorkshop.WorkOrders.WorkOrderService do
  use Ecto.Schema
  import Ecto.Changeset
  alias CarWorkshop.WorkOrders.WorkOrder
  alias CarWorkshop.Services.Service

  @primary_key false
  schema "work_order_services" do
    field :qty, :integer, default: 0

    belongs_to :work_order, WorkOrder
    belongs_to :service, Service

    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:work_order_id, :service_id, :qty])
    |> validate_required([:work_order_id, :service_id, :qty])
  end
end
