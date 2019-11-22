defmodule Popo.Repo.Migrations.LocationSplit do
  use Ecto.Migration

  def change do
     alter table("users") do 
       remove :location
       add :latitude, :float, default: nil, null: true
       add :longtitude, :float, default: nil, null: true
     end
  end
end
