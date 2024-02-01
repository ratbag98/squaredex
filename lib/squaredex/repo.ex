defmodule Squaredex.Repo do
  use Ecto.Repo,
    otp_app: :squaredex,
    adapter: Ecto.Adapters.Postgres
end
