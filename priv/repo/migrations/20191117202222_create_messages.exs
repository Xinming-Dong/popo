defmodule Popo.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :time, :naive_datetime
      add :from, references(:users, on_delete: :nothing)
      add :to, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:from])
    create index(:messages, [:to])
  end
end
