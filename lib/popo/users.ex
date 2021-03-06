defmodule Popo.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Popo.Repo

  alias Popo.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end
    def authenticate(email, pass) do
    user = Repo.get_by(User, email: email)
    case Argon2.check_pass(user, pass) do
      {:ok, user} -> user
      _ -> nil
    end
  end

  def get_nearby(user) do
    if user.longitude == nil || user.latitude == nil do
      nil
    else
      query = from u in User,
          where: (u.longitude - ^user.longitude)*(u.longitude - ^user.longitude) + (u.latitude - ^user.latitude) * (u.latitude - ^user.latitude) < 0.000072 and u.id != ^user.id
      Repo.all(query)
    end
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_name_by_id(id) do
    query = from u in "users", where: u.id == ^id, select: %{name: u.name}
    Repo.one(query)
  end

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_user_with_posts!(id) do
    Repo.one from uu in User,
      where: uu.id == ^id,
      preload: [:posts]
  end
end
