defmodule PhxChat.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :username, :string
      add :account_id, :string
      add :ref_id, references(:users, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:contacts, [:ref_id])
    create index(:contacts, [:user_id])
  end
end
