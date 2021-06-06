# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CarWorkshop.Repo.insert!(%CarWorkshop.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

services = [
  %{name: "Servicio escaner multimarca", price: 0.0},
  %{name: "Cambio aceite y filtro", price: 0.0},
  %{name: "Liquido refrigerante", price: 0.0},
  %{name: "Transmisión", price: 0.0},
  %{name: "Pintura", price: 0.0},
  %{name: "Batería", price: 0.0},
  %{name: "Afinacion", price: 0.0},
  %{name: "Compresión", price: 0.0},
  %{name: "Presión combustible", price: 0.0},
  %{name: "Suspensión", price: 0.0},
  %{name: "Chequeo luces", price: 0.0},
  %{name: "Mantenimiento inyectores", price: 0.0},
  %{name: "Reparacion alternador", price: 0.0},
  %{name: "Alarmas", price: 0.0},
  %{name: "Chequeo vidrios", price: 0.0},
  %{name: "Cambio plumillas", price: 0.0},
  %{name: "Mecanica en general", price: 0.0},
  %{name: "Venta de repuestos", price: 0.0},
  %{name: "Reparacion y carga aire acondicionado", price: 0.0},
  %{name: "Polarizacion vidrios", price: 0.0},
  %{name: "Puesta a punto analizador gases", price: 0.0},
  %{name: "Prueba y lavado de inyectores", price: 0.0}
]

Enum.map(services, &CarWorkshop.Services.create_service(&1))
