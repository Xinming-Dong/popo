defmodule Popo.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :time, :naive_datetime
    field :from, :id
    field :to, :id

    belongs_to :user, Popo.Users.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :time, :from, :to])
    |> validate_required([:content, :time, :from, :to])
  end
end
