defmodule Y.Repo do
  use Ecto.Repo,
    otp_app: :y,
    adapter: Ecto.Adapters.Postgres
end
