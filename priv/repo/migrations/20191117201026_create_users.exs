defmodule Popo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :password, :string
      add :location, :map

      timestamps()
    end

  end
end
