defmodule Popo.Repo.Migrations.AddFilenameProfile do
  use Ecto.Migration

  def change do
      alter table(:profiles) do
        remove :photo
        add :filename, :string
      end
  end
end
