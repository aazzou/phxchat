defmodule PhxChat.Chat.UserConversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_conversations" do
    belongs_to :user, PhxChat.Accounts.User
    belongs_to :conversation, PhxChat.Chat.Conversation
    timestamps()
  end

  @doc false
  def changeset(user_conversation, attrs) do
    user_conversation
    |> cast(attrs, [:user_id, :conversation_id])
    |> validate_required([])
  end
end
