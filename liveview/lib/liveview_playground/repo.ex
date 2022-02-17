defmodule LiveviewPlayground.Repo do
  use Ecto.Repo,
    otp_app: :liveview_playground,
    adapter: Ecto.Adapters.Postgres
end
