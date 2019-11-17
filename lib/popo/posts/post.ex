defmodule Popo.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :description, :string
    field :location, :map
    field :photo, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:description, :photo, :location])
    |> validate_required([:description, :photo, :location])
  end
end
