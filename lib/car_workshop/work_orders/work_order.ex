defmodule CarWorkshop.WorkOrders.WorkOrder do
  use Ecto.Schema
  import Ecto.Changeset
  alias CarWorkshop.WorkOrders.WorkOrderService

  schema "work_orders" do
    field :plate, :string
    field :mechanic, :string

    has_many :work_order_services, WorkOrderService, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(work_order, attrs) do
    work_order
    |> cast(attrs, [:plate, :mechanic])
    |> validate_required([:plate, :mechanic])
    |> validate_length(:plate, min: 6, max: 6)
    |> validate_length(:mechanic, min: 6)
    |> maybe_put_assoc(attrs["work_order_services"])
  end

  defp maybe_put_assoc(%Ecto.Changeset{valid?: false} = changeset, _), do: changeset

  defp maybe_put_assoc(changeset, work_order_services),
    do: put_assoc(changeset, :work_order_services, work_order_services)
end
