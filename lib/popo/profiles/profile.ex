defmodule Popo.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :dob, :date
    field :gender, :string
    field :intro, :string
    belongs_to :user, Popo.Users.User

    field :uuid, :string
    field :filename, :string
    field :photo, :any, virtual: true


    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:dob, :gender, :intro, :photo, :user_id])
    |> generate_uuid()
    |> save_photo_upload()
  end

  def make_uuid() do
    :crypto.strong_rand_bytes(16)
    |> Base.encode16
  end

  def generate_uuid(cset) do

    if get_field(cset, :uuid) || get_field(cset, :photo) == nil do
      cset
    else
      put_change(cset, :uuid, make_uuid())
    end
  end

  def save_photo_upload(cset) do

    up = get_field(cset, :photo)
    uuid = get_field(cset, :uuid)
    if up do
      dir = photo_upload_dir(uuid)
      File.mkdir_p!(dir)
      File.copy!(up.path, Path.join(dir, up.filename))
      put_change(cset, :filename, up.filename)
    else
      cset
    end
  end

  def photo_upload_dir(uuid) do
    base = Path.expand("~/.local/data/popo/photos/")
    Path.join(base, uuid)
  end
end
