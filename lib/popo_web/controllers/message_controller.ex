defmodule PopoWeb.MessageController do
  use PopoWeb, :controller

  alias Popo.Messages
  alias Popo.Messages.Message

  def chat(conn, _params) do
    # {int_id, _} = Integer.parse(id)
    int_id = conn.assigns[:current_user].id
    name = Popo.Users.get_user_name_by_id(int_id).name
    friends = Popo.Friends.get_friend_list_by_user_id(int_id) # get list of friends
    friends = Enum.map(friends, fn fr ->
      %{user_2_id: fr.user_2_id, user_2_name: Popo.Users.get_user_name_by_id(fr.user_2_id).name}
    end)
    render(conn, "chat.html", id: int_id, name: name, friends: friends)
  end

  def index(conn, _params) do
    messages = Messages.list_messages()
    render(conn, "index.html", messages: messages)
  end

  def new(conn, _params) do
    changeset = Messages.change_message(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    case Messages.create_message(message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: Routes.message_path(conn, :show, message))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Messages.get_message!(id)
    render(conn, "show.html", message: message)
  end

  def edit(conn, %{"id" => id}) do
    message = Messages.get_message!(id)
    changeset = Messages.change_message(message)
    render(conn, "edit.html", message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Messages.get_message!(id)

    case Messages.update_message(message, message_params) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message updated successfully.")
        |> redirect(to: Routes.message_path(conn, :show, message))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Messages.get_message!(id)
    {:ok, _message} = Messages.delete_message(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: Routes.message_path(conn, :index))
  end
end
