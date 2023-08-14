defmodule Tails.Repo do
  use Ecto.Repo,
    otp_app: :tails,
    adapter: Ecto.Adapters.Postgres

  defdelegate normalize_one_result(result), to: Tails.Ecto.Results
  defdelegate normalize_one_result(result, message), to: Tails.Ecto.Results
end
