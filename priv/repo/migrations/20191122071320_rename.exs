defmodule Popo.Repo.Migrations.Rename do
  use Ecto.Migration

  def change do
    alter table("users") do 
       remove :longtitude
	add :longitude, :float, default: nil, null: true
   end
   

  end
end
