defmodule Popo.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :dob, :date
    field :gender, :string
    field :intro, :string
    field :photo, :string
    belongs_to :user, Popo.Users.User

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:dob, :gender, :intro, :photo, :user_id])
  end
end
