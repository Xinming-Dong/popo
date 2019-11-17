defmodule Popo.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :time, :naive_datetime
    field :from, :id
    field :to, :id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :time])
    |> validate_required([:content, :time])
  end
end
