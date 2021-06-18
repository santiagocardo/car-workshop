defmodule CarWorkshop.Reports do
  @moduledoc """
  The Reports context.
  """

  import Ecto.Query, warn: false
  alias CarWorkshop.Repo

  alias CarWorkshop.Reports.Report
  alias CarWorkshop.WorkOrders.WorkOrder

  @search_limit 20

  @doc """
  Returns the list of reports.

  ## Examples

      iex> list_reports()
      [%Report{}, ...]

  """
  def list_reports do
    from(r in Report, order_by: [desc: r.id], limit: @search_limit)
    |> Repo.all()
  end

  def count_reports, do: Repo.one(from r in Report, select: fragment("count(*)"))

  @doc """
  Gets a single report.

  Raises `Ecto.NoResultsError` if the Report does not exist.

  ## Examples

      iex> get_report!(123)
      %Report{}

      iex> get_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_report!(id) do
    Repo.get!(Report, id)
    |> Repo.preload(work_order: [work_order_services: :service], customer: [])
  end

  def get_reports_by_plate(plate) do
    from(r in Report,
      where: r.plate == ^plate,
      order_by: [desc: r.id],
      limit: @search_limit
    )
    |> Repo.all()
  end

  def search_reports(query_opts, nil, page), do: find_reports(query_opts, page, & &1)

  def search_reports(query_opts, esp_opts, page) do
    filter_func = fn query ->
      query
      |> maybe_put_date_since_filter(esp_opts)
      |> maybe_put_date_until_filter(esp_opts)
      |> maybe_put_mechanic_filter(esp_opts)
    end

    find_reports(query_opts, page, filter_func)
  end

  def find_reports(query_opts, page, func) do
    offset = if page == 1, do: 0, else: (page - 1) * @search_limit

    from(r in Report,
      where: ^query_opts,
      order_by: [desc: r.id],
      offset: ^offset,
      limit: @search_limit
    )
    |> func.()
    |> Repo.all()
  end

  @doc """
  Creates a report.

  ## Examples

      iex> create_report(%{field: value})
      {:ok, %Report{}}

      iex> create_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_report(attrs \\ %{}) do
    %Report{}
    |> Report.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a report.

  ## Examples

      iex> update_report(report, %{field: new_value})
      {:ok, %Report{}}

      iex> update_report(report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_report(%Report{} = report, attrs) do
    report
    |> Report.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a report.

  ## Examples

      iex> delete_report(report)
      {:ok, %Report{}}

      iex> delete_report(report)
      {:error, %Ecto.Changeset{}}

  """
  def delete_report(%Report{} = report) do
    Repo.delete(report)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking report changes.

  ## Examples

      iex> change_report(report)
      %Ecto.Changeset{data: %Report{}}

  """
  def change_report(%Report{} = report, attrs \\ %{}) do
    Report.changeset(report, attrs)
  end

  defp maybe_put_date_since_filter(query, %{"date_since" => ""}), do: query

  defp maybe_put_date_since_filter(query, %{"date_since" => date}) do
    datetime = Date.from_iso8601!(date)

    where(query, [r], fragment("?::date", r.updated_at) >= ^datetime)
  end

  defp maybe_put_date_until_filter(query, %{"date_until" => ""}), do: query

  defp maybe_put_date_until_filter(query, %{"date_until" => date}) do
    datetime = Date.from_iso8601!(date)

    where(query, [r], fragment("?::date", r.updated_at) <= ^datetime)
  end

  defp maybe_put_mechanic_filter(query, %{"mechanic" => ""}), do: query

  defp maybe_put_mechanic_filter(query, %{"mechanic" => mechanic}) do
    join(query, :inner, [r], w in WorkOrder,
      on: r.work_order_id == w.id and w.mechanic == ^mechanic
    )
  end
end
