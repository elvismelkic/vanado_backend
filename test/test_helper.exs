ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(VanadoBackend.Repo, :manual)

Mox.defmock(VanadoBackend.Api.MockFile, for: VanadoBackend.Api.File)
