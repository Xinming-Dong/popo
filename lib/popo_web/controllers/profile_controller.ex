defmodule PopoWeb.ProfileController do
  use PopoWeb, :controller

  alias Popo.Profiles
  alias Popo.Profiles.Profile

  def index(conn, _params) do
    profiles = Profiles.list_profiles()
    render(conn, "index.html", profiles: profiles)
  end

  def new(conn, params) do
    user_id = String.to_integer(params["user_id"])
    changeset = Profiles.change_profile(%Profile{})
    render(conn, "new.html", changeset: changeset, user_id: user_id)
  end

  def create(conn, %{"profile" => profile_params, "user_id" => user_id}) do
    profile_params = Map.put(profile_params, "user_id", user_id)
    IO.inspect(profile_params)
    case Profiles.create_profile(profile_params) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profile created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    profile = Profiles.get_profile_by_user(id)
    render(conn, "show.html", profile: profile)
  end

  def edit(conn, %{"id" => id}) do
    profile = Profiles.get_profile!(id)
    changeset = Profiles.change_profile(profile)
    render(conn, "edit.html", profile: profile, changeset: changeset)
  end

  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = Profiles.get_profile!(id)

    case Profiles.update_profile(profile, profile_params) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: Routes.profile_path(conn, :show, conn.assigns[:current_user].id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", profile: profile, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    profile = Profiles.get_profile!(id)
    {:ok, _profile} = Profiles.delete_profile(profile)

    conn
    |> put_flash(:info, "Profile deleted successfully.")
    |> redirect(to: Routes.profile_path(conn, :index))
  end

  def file(conn, %{"id" => id}) do
    profile = Profiles.get_profile!(id)
    dir = Profile.photo_upload_dir(profile.uuid)
    data = File.read!(Path.join(dir, profile.filename))
    conn
    |> put_resp_header("content-type", "image/jpeg")
    |> put_resp_header("content-disposition", "inline")
    |> send_resp(200, data)
  end
end
