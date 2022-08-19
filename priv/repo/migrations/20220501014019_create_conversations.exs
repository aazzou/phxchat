defmodule PhxChat.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations) do
      add :uuid, :string

      timestamps()
    end

    create unique_index(:conversations, [:uuid])
  end
end
