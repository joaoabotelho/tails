defmodule Tails.Repo do
  use Ecto.Repo,
    otp_app: :tails,
    adapter: Ecto.Adapters.Postgres
end
