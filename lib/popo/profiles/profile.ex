defmodule Popo.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :dob, :date
    field :gender, :string
    field :intro, :string
    field :photo, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:dob, :gender, :intro, :photo])
    |> validate_required([:dob, :gender, :intro, :photo])
  end
end
