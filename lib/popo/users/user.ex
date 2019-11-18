defmodule Popo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :location, :map
    field :name, :string
    field :password, :string
    field :password_confirmation, :string, virtual: true
    has_one :profile, Popo.Profiles.Profile
    

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :location, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 12)
    |> validate_required([:email, :name, :password])
  end
end
