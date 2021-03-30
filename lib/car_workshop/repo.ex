defmodule CarWorkshop.Repo do
  use Ecto.Repo,
    otp_app: :car_workshop,
    adapter: Ecto.Adapters.Postgres
end
