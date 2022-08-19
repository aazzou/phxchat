defmodule PhxChat.Chat do
  import Ecto.Query, warn: false

  alias PhxChat.Repo
  alias PhxChat.Accounts.User
  alias PhxChat.Chat.Contact
  alias PhxChat.Chat.Conversation
  alias PhxChat.Chat.Message
  alias PhxChat.Chat.UserConversation

  require Logger


  def get_contact(id) do
    Repo.get!(Contact, id)
  end

  def get_or_create_conversation(current_user, contact) do
    uuid = generate_uuid(current_user, contact)
    case get_conversation(current_user, contact) do
      {:ok, conversation} -> {:ok, conversation}
      {:error, _error } ->
        %{uuid: uuid, user_id: current_user.id, contact_ref_id: contact.ref_id} |> create_conversation
    end
  end

  def get_conversation(current_user, contact) do
    try do
      user_conversation = from(uc in UserConversation, where: uc.user_id == ^current_user.id)
      |> Repo.all()
      |> Enum.map( fn uc -> uc.conversation_id end )

      contact_conversation = from(uc in UserConversation, where: (uc.user_id == ^contact.ref_id) and (uc.conversation_id in ^user_conversation) )
      |> Repo.all()
      |> Enum.at(0)
      |> Repo.preload(:conversation)

      {:ok, contact_conversation.conversation}
    rescue
      e ->
        Logger.error(e)
        {:error, e}
    end
  end

  def create_conversation(attrs \\ %{}) do
    try do
      %Conversation{}
      |> Conversation.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:users, users_conversations(attrs))
      |> Repo.insert()
    rescue
      e ->
        Logger.error(e)
        {:error, e}
    end
  end

  defp users_conversations(attrs \\ %{}) do
    Repo.all(from u in User, where: (u.id == ^attrs[:user_id]) or (u.id == ^attrs[:contact_ref_id]))
  end

  def conversation_exists(user_id, contact_id) do
    try do
      conversation = Repo.get_by(UserConversation, user_id: user_id)
      if conversation.id == Repo.get_by(UserConversation, user_id: contact_id).conversation_id do
        {:ok, conversation}
      else
        {:error, %{}}
      end
    rescue
      e ->
        Logger.error(e)
        {:error, e}
    end
  end

  def get_conversation_by_uuid(uuid) do
    Repo.get_by(Conversation, uuid: uuid)
    |> Repo.preload(:messages)
  end

  def contact_changeset(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end

  def add_contact(current_user, attrs) do
    try do
      new_attrs = Map.put(attrs, "ref_id",
                  Repo.get_by(User, account_id: attrs["account_id"] ).id )
                  |> Map.put("user_id", current_user.id )
      %Contact{}
      |> Contact.changeset(new_attrs)
      |> Repo.insert()
    rescue
      e ->
        Logger.error(e)
        {:error, e}
    end
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:message_created)
  end

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(PhxChat.PubSub, topic)
  end

  # some private functions
  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, message}, event) do
    Phoenix.PubSub.broadcast(PhxChat.PubSub, "conversation-#{message.conversation_id}", {event, message})
    {:ok, message}
  end
  defp generate_uuid(current_user, contact), do: current_user.account_id <> "-" <> contact.username

end
