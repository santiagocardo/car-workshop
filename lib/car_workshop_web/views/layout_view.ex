defmodule CarWorkshopWeb.LayoutView do
  use CarWorkshopWeb, :view

  def count_vehicles() do
    CarWorkshop.Vehicles.list_vehicles()
    |> Enum.count()
  end

  def count_users() do
    CarWorkshop.Accounts.list_customers()
    |> Enum.count()
  end
end
