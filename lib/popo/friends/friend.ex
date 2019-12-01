defmodule Popo.Friends.Friend do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friends" do
    field :user_1, :id
    field :user_2, :id

    belongs_to :user, Popo.Users.User

    timestamps()
  end

  @doc false
  def changeset(friend, attrs) do
    friend
    |> cast(attrs, [:user_1, :user_2])
    |> validate_required([:user_1, :user_2])
  end
end
