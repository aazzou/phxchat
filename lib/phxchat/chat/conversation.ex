defmodule PhxChat.Chat.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversations" do
    field :uuid, :string
    many_to_many :users, PhxChat.Accounts.User, join_through: "users_conversations"

    has_many :messages, PhxChat.Chat.Message
    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:uuid])
    |> validate_required([:uuid])
    |> unique_constraint(:uuid)
  end
end
