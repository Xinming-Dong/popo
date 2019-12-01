defmodule Popo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :latitude, :float
    field :longitude, :float
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_one :profile, Popo.Profiles.Profile
    has_many :posts, Popo.Posts.Post
    has_many :messages, Popo.Messages.Message
    has_many :friends, Popo.Friends.Friend


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :longitude, :latitude, :password_confirmation])
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 12)
    |> hash_password()
    |> validate_required([:email, :name, :password_hash])
  end

    def hash_password(cset) do
    pw = get_change(cset, :password)
    if pw do
      change(cset, Argon2.add_hash(pw))
    else
      cset
    end
  end
end
