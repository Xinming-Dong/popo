defmodule PopoWeb.SessionController do
  use PopoWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email}) do
    user = Popo.Users.get_user_by_email(email)
    IO.puts ">>>>>>>>>>> session controllser create"
    IO.inspect user
    id = user.id
    name = user.name
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.email}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    user = Popo.Users.get_user(get_session(conn, :user_id))
    Popo.Users.update_user(user, %{latitude: nil, longitude: nil}) 
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
