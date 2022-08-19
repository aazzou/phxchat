defmodule PhxChat.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :text, :string

    belongs_to :user, PhxChat.Accounts.User
    belongs_to :conversation, PhxChat.Chat.Conversation
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :user_id, :conversation_id])
    |> validate_required([:text, :user_id, :conversation_id])
  end
end
