defmodule PopoWeb.PostController do
  use PopoWeb, :controller

  alias Popo.Posts
  alias Popo.Posts.Post
  alias Popo.Users
  alias Popo.GeocodeApi


  def index(conn, params) do
    IO.inspect params
    user = Users.get_user_with_posts!(Map.get(params, :user_id))
    render(conn, "index.html", user: user)
  end

  def new(conn, %{"type" => type}) do
    case type do
      "updateLocation" ->
      conn
        |>redirect(to: Routes.user_path(conn, :edit, conn.assigns[:current_user].id, type: "post"))
      "newpost" ->
        changeset = Posts.change_post(%Post{})
        locations = GeocodeApi.getPOI(%{:latitude=>conn.assigns[:current_user].latitude,
        :longitude=>conn.assigns[:current_user].longitude})
        render(conn, "new.html", changeset: changeset, locations: locations)
    end
  end

  def create(conn, %{"post" => post_params}) do
    post_params = Map.put(post_params, "user_id", conn.assigns[:current_user].id)
    IO.inspect post_params
    case Posts.create_post(post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :index, user_id: conn.assigns[:current_user].id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "type" => display, "location" => location}) do
    cond do
      display == "nearby"->
        user = Users.get_user!(id)
        posts = Posts.get_nearby(user)
        render(conn, "show_nearby.html", posts: posts, location: nil)
      display == "location"->
        posts = Posts.get_at_location(location)
        render(conn, "show_nearby.html", posts: posts, location: location)
      true ->
        post = Posts.get_post!(id)
        render(conn, "show.html", post: post)
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Posts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def file(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    dir  = Post.photo_upload_dir(post.uuid)
    data = File.read!(Path.join(dir, post.filename))
    conn
    |> put_resp_header("content-type", "image/jpeg")
    |> put_resp_header("content-disposition", "inline")
    |> send_resp(200, data)
  end


end
