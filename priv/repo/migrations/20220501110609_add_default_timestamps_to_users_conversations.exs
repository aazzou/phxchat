defmodule PhxChat.Repo.Migrations.AddDefaultTimestampsToUsersConversations do
  use Ecto.Migration

  def change do
    alter table(:users_conversations) do
      modify :inserted_at, :naive_datetime, default: fragment("NOW()")
      modify :updated_at, :naive_datetime, default: fragment("NOW()")
    end
  end
end
