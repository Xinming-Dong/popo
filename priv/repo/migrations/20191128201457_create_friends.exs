defmodule Popo.Repo.Migrations.CreateFriends do
  use Ecto.Migration

  def change do
    create table(:friends) do
      add :user_1, references(:users, on_delete: :delete_all), null: false
      add :user_2, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:friends, [:user_1])
    create index(:friends, [:user_2])
  end
end
