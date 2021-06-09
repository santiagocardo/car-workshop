defmodule CarWorkshopWeb.LayoutView do
  use CarWorkshopWeb, :view

  def count_vehicles() do
    CarWorkshop.Vehicles.list_vehicles()
    |> Enum.count()
  end

  def count_work_orders() do
    CarWorkshop.WorkOrders.list_work_orders()
    |> Enum.count()
  end

  def count_reports() do
    CarWorkshop.Reports.count_reports()
  end
end
