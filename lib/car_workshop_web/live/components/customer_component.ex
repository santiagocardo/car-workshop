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

    validation_response = fn socket, customer_params ->
      {:noreply,
       assign(
         socket,
         changeset: validate_changeset(customer_params, socket)
       )}
    end

    if String.length(idn) > 7 and socket.assigns.action == :new do
      case Accounts.get_customer_by_identity_number(idn) do
        nil ->
          validation_response.(socket, customer_params)

        customer ->
          send(self(), {:customer, customer, :existing})

          {:noreply, socket}
      end
    else
      validation_response.(socket, customer_params)
    end
  end

  @impl true
  def handle_event("save", %{"customer" => customer_params}, socket) do
    changeset = validate_changeset(customer_params, socket)

    case changeset.errors do
      [] ->
        send(self(), {:customer, customer_params, :save})

        {:noreply, socket}

      _ ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp validate_changeset(customer_params, socket) do
    socket.assigns.customer
    |> Accounts.change_customer(customer_params)
    |> Map.put(:action, :validate)
  end
end
