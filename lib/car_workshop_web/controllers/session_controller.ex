defmodule CarWorkshopWeb.SessionController do
  use CarWorkshopWeb, :controller

  alias CarWorkshop.Accounts

  plug :put_root_layout, "session.html"

  def new(conn, _params) do
    if get_session(conn, :user_id) do
      redirect(conn, to: Routes.vehicle_index_path(conn, :new))
    else
      render(conn, "new.html")
    end
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Accounts.authenticate_by_username_and_pass(username, password) do
      {:ok, user} ->
        conn
        |> CarWorkshopWeb.Auth.login(user)
        |> redirect(to: Routes.vehicle_index_path(conn, :new))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Usuario o contraseña inválidos")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> CarWorkshopWeb.Auth.logout()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
