defmodule CarWorkshop.WorkOrders.WorkOrder do
  use Ecto.Schema
  import Ecto.Changeset
  alias CarWorkshop.WorkOrders.WorkOrderService

  schema "work_orders" do
    field :plate, :string
    field :mechanic, :string
    field :is_completed, :boolean, null: false

    has_many :work_order_services, WorkOrderService
    has_many :reports, CarWorkshop.Reports.Report

    timestamps()
  end

  @doc false
  def changeset(work_order, attrs) do
    work_order
    |> cast(attrs, [:plate, :mechanic, :is_completed])
    |> validate_required([:plate, :mechanic])
    |> validate_length(:plate, min: 6, max: 6)
    |> validate_length(:mechanic, min: 6)
    |> maybe_put_assoc(attrs)
  end

  defp maybe_put_assoc(changeset, work_order_services) when is_list(work_order_services) do
    case changeset do
      %Ecto.Changeset{valid?: false} -> changeset
      %Ecto.Changeset{changes: %{is_completed: true}} -> changeset
      _ -> put_assoc(changeset, :work_order_services, work_order_services)
    end
  end

  defp maybe_put_assoc(changeset, %{"work_order_services" => wos}),
    do: maybe_put_assoc(changeset, wos)

  defp maybe_put_assoc(changeset, %{work_order_services: wos}),
    do: maybe_put_assoc(changeset, wos)

  defp maybe_put_assoc(changeset, _attrs), do: changeset
end
