defmodule VanadoBackend.Repo do
  use Ecto.Repo,
    otp_app: :vanado_backend,
    adapter: Ecto.Adapters.Postgres
end
