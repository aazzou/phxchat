defmodule PhxChat.Repo do
  use Ecto.Repo,
    otp_app: :phxchat,
    adapter: Ecto.Adapters.Postgres
end
