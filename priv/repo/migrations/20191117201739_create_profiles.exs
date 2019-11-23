defmodule Popo.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :dob, :date
      add :gender, :string
      add :intro, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :uuid, :string
      add :filename, :string

      timestamps()
    end

    create index(:profiles, [:user_id])
  end
end
