defmodule Phxchat.Chat.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :account_id, :string
    field :username, :string
    field :ref_id, :id

    belongs_to :user, PhxChat.Accounts.User
    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:username, :account_id, :ref_id, :user_id])
    |> validate_required([:username, :account_id])
  end
end
