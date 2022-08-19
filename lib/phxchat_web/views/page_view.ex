defmodule PhxChatWeb.PageView do
  use PhxChatWeb, :view
  alias PhxChat.Chat

  def contact_username(id) do
    Chat.get_contact(id).username
  end

  # def contact_username_from_conversation(current_user, uuid) do
  #   conversation = Repo.get_by(Conversation, uuid: uuid)
  #   user = ( Repo.all(
  #     from(uc in UserConversation, where: uc.conversation_id == ^conversation.id and uc.user_id != ^current_user.id)
  #   ) |> Repo.preload(:user) |> Enum.at(0) ).user

  #   ( Repo.get_by(Contact, ref_id: user.id) ).username
  # end
end
