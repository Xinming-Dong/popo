defmodule PopoWeb.UserController do
  use PopoWeb, :controller

  alias Popo.Users
  alias Popo.Users.User
  alias Popo.MapApi

  def index(conn, params) do
    user=Users.get_user!(params["user_id"])
    IO.inspect user
    users = Users.get_nearby(user)
    IO.inspect(users)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        IO.inspect(user.id)
        conn
        |> put_flash(:info, "Please edit your profile.")
        |> redirect(to: Routes.profile_path(conn, :new, user_id: user.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do 
    user = Users.get_user!(id)
    users = Users.get_nearby(user)
    image = MapApi.getLocation(user, users)
    render(conn, "show.html", users: users, user: user,image: image)
  end


  def edit(conn, %{"id" => id, "type" => type}) do
      user = Users.get_user!(id)
      changeset = Users.change_user(user)
      case type do
        "post"->
          render(conn, "edit.html", user: user, changeset: changeset)
        "user"->
          render(conn, "edit1.html", user: user, changeset: changeset)
      end

  end

  def update(conn, %{"id" => id, "user" => user_params, "type" =>type}) do
    user = Users.get_user!(id)
    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        case type do
          "post"->
            conn
            |>redirect(to: Routes.post_path(conn, :new, %{"type"=>"newpost"}))
          "user" ->
            conn
            |> redirect(to: Routes.user_path(conn, :show, user))
        end
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

end
