defmodule Popo.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :uuid, :string
      add :filename, :string
      add :location, :map


      timestamps()
    end

    create index(:posts, [:user_id])
  end
end
