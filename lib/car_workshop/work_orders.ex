defmodule CarWorkshop.WorkOrders do
  @moduledoc """
  The WorkOrders context.
  """

  import Ecto.Query, warn: false
  alias CarWorkshop.Repo

  alias CarWorkshop.WorkOrders.{WorkOrder, WorkOrderService}

  @doc """
  Returns the list of work_orders.

  ## Examples

      iex> list_work_orders()
      [%WorkOrder{}, ...]

  """
  def list_work_orders do
    from(w in WorkOrder, where: w.is_completed == false)
    |> Repo.all()
  end

  @doc """
  Gets a single work_order.

  Raises `Ecto.NoResultsError` if the Work order does not exist.

  ## Examples

      iex> get_work_order!(123)
      %WorkOrder{}

      iex> get_work_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_order!(id) do
    WorkOrder
    |> Repo.get!(id)
    |> Repo.preload(work_order_services: :service)
  end

  def get_work_order_by_plate(plate) do
    from(w in WorkOrder,
      where: w.plate == ^plate,
      order_by: [desc: w.id],
      limit: 1
    )
    |> Repo.all()
    |> Enum.at(0)
  end

  @doc """
  Creates a work_order.

  ## Examples

      iex> create_work_order(%{field: value})
      {:ok, %WorkOrder{}}

      iex> create_work_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_order(attrs \\ %{}) do
    %WorkOrder{}
    |> WorkOrder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_order.

  ## Examples

      iex> update_work_order(work_order, %{field: new_value})
      {:ok, %WorkOrder{}}

      iex> update_work_order(work_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_order(%WorkOrder{} = work_order, attrs) do
    work_order
    |> Map.put(:work_order_services, [])
    |> WorkOrder.changeset(attrs)
    |> maybe_delete_work_order_services(work_order.id)
    |> Repo.update()
  end

  @doc """
  Deletes a work_order.

  ## Examples

      iex> delete_work_order(work_order)
      {:ok, %WorkOrder{}}

      iex> delete_work_order(work_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_order(%WorkOrder{} = work_order) do
    Repo.delete(work_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_order changes.

  ## Examples

      iex> change_work_order(work_order)
      %Ecto.Changeset{data: %WorkOrder{}}

  """
  def change_work_order(%WorkOrder{} = work_order, attrs \\ %{}) do
    WorkOrder.changeset(work_order, attrs)
  end

  defp maybe_delete_work_order_services(changeset, work_order_id) do
    case changeset do
      %Ecto.Changeset{valid?: false} ->
        changeset

      %Ecto.Changeset{changes: %{is_completed: true}} ->
        changeset

      _ ->
        from(w in WorkOrderService, where: w.work_order_id == ^work_order_id)
        |> Repo.delete_all()

        changeset
    end
  end
end
