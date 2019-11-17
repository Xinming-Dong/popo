defmodule Popo.Repo do
  use Ecto.Repo,
    otp_app: :popo,
    adapter: Ecto.Adapters.Postgres
end
