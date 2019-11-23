defmodule Popo.Repo.Migrations.AddPostLocation do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :location
      add :latitude, :float, defaut: nil, null: true
      add :longitude, :float, default: nil, null: true
     end

  end
end
