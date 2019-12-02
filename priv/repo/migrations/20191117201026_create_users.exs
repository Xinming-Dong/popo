defmodule Popo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :password_hash, :string, default: nil, null: false
      add :latitude, :float, default: nil, null: true
      add :longitude, :float, default: nil, null: true

      timestamps()
    end

  end
end
