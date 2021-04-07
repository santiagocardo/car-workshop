defmodule CarWorkshopWeb.CustomerComponent do
  use CarWorkshopWeb, :live_component

  alias CarWorkshop.Accounts

  @impl true
  def update(%{customer: customer} = assigns, socket) do
    changeset = Accounts.change_customer(customer)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"customer" => customer_params}, socket) do
    idn = customer_params["identity_number"]

    changeset =
      socket.assigns.customer
      |> Accounts.change_customer(customer_params)
      |> Map.put(:action, :validate)

    if String.length(idn) > 7 and socket.assigns.action == :new do
      case Accounts.get_customer_by_identity_number(idn) do
        nil ->
          {:noreply, assign(socket, changeset: changeset)}

        customer ->
          send(self(), {:customer_registered, customer, :customer_view})

          {:noreply, socket}
      end
    else
      {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("save", %{"customer" => customer_params}, socket) do
    case Accounts.create_customer(customer_params) do
      {:ok, customer} ->
        send(self(), {:customer_registered, customer, :vehicle_view})

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
