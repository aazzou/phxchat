defmodule PhxChat.Repo.Migrations.CreateUsersConversations do
  use Ecto.Migration

  def change do
    create table(:users_conversations) do
      add :user_id, references(:users, on_delete: :nothing)
      add :conversation_id, references(:conversations, on_delete: :nothing)

      timestamps()
    end

    create index(:users_conversations, [:user_id])
    create index(:users_conversations, [:conversation_id])
  end
end
