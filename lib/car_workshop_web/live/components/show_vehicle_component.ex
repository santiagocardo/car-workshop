defmodule CarWorkshopWeb.ShowVehicleComponent do
  use CarWorkshopWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="flex-auto px-4 lg:px-10 pb-10">
      <hr class="mt-6 border-b-1 border-gray-300" />

      <h6 class="text-gray-400 text-sm mt-3 mb-6 font-bold uppercase">
        Información del Vehículo
      </h6>
      <div class="flex flex-wrap">
        <div class="w-full md:w-6/12 lg:w-4/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Placa:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.plate %></p>
        </div>
        <div class="w-full md:w-6/12 lg:w-4/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Marca:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.brand %></p>
        </div>
        <div class="w-full md:w-6/12 lg:w-4/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Modelo:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.model %></p>
        </div>
        <div class="w-full md:w-6/12 lg:w-4/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Color:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.color %></p>
        </div>
        <div class="w-full md:w-6/12 lg:w-4/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Clase:
          </span>
          <p class="inline-block text-sm">
            <%= if @vehicle.class == "car" do "Carro" else "Moto" end %>
          </p>
        </div>
        <div class="w-full md:w-6/12 lg:w-4/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Kilometraje:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.km %></p>
        </div>
        <div class="w-full md:w-6/12 lg:w-4/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Combustible:
          </span>
          <p class="inline-block text-sm">
            <%= if @vehicle.fuel_type == "gas" do "Gasolina" else "Diesel" end %>
          </p>
        </div>
        <%= if @vehicle.chassis do %>
          <div class="w-full md:w-6/12 lg:w-4/12 px-4 py-2">
            <span class="uppercase text-gray-600 text-xs font-bold mb-2">
              Chasis:
            </span>
            <p class="inline-block text-sm"><%= @vehicle.chassis %></p>
          </div>
        <% end %>
      </div>

      <hr class="mt-6 border-b-1 border-gray-300" />

      <h6 class="text-gray-400 text-sm mt-3 mb-6 font-bold uppercase">
        Condiciones externas del vehículo
      </h6>
      <div class="flex flex-wrap">
        <div class="w-full lg:w-12/12 px-4">
          <span class="block uppercase text-gray-600 text-xs font-bold mb-2">
            Observaciones
          </span>
          <p class="text-sm"><%= @vehicle.notes %></p>
        </div>
      </div>

      <%= if @vehicle.photos != [] do %>
        <hr class="mt-6 border-b-1 border-gray-300" />

        <h6 class="text-gray-400 text-sm mt-3 mb-6 font-bold uppercase">
          registro fotográfico del vehículo
        </h6>
        <div class="flex flex-wrap">
          <%= for photo_url <- @vehicle.photos do %>
            <div class="w-full lg:w-6/12 px-4">
              <div class="relative w-full mb-3">
                <img load="lazy" src="<%= photo_url %>" height="150" />
              </div>
            </div>
          <% end %>
        </div>
      <% end %>

      <hr class="mt-6 border-b-1 border-gray-300" />

      <h6 class="text-gray-400 text-sm mt-3 mb-6 font-bold uppercase">
        Información del propietario
      </h6>
      <div class="flex flex-wrap">
        <div class="w-full sm:w-6/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            RUT/cédula:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.customer.identity_number %></p>
        </div>
        <div class="w-full sm:w-6/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Nombre:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.customer.name %></p>
        </div>
        <div class="w-full sm:w-6/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Celular:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.customer.phone %></p>
        </div>
        <div class="w-full sm:w-6/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Correo:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.customer.email %></p>
        </div>
        <div class="w-full sm:w-6/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Dirección:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.customer.address %></p>
        </div>
        <div class="w-full sm:w-6/12 px-4 py-2">
          <span class="uppercase text-gray-600 text-xs font-bold mb-2">
            Ciudad:
          </span>
          <p class="inline-block text-sm"><%= @vehicle.customer.city %></p>
        </div>
      </div>
    </div>
    """
  end
end
