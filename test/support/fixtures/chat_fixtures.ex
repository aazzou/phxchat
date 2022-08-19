defmodule PhxChat.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhxChat.Chat` context.
  """

  @doc """
  Generate a conversation.
  """
  def conversation_fixture(attrs \\ %{}) do
    {:ok, conversation} =
      attrs
      |> Enum.into(%{

      })
      |> PhxChat.Chat.create_conversation()

    conversation
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> PhxChat.Chat.create_message()

    message
  end

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        account_id: "some accound_id",
        username: "some username"
      })
      |> PhxChat.Chat.create_contact()

    contact
  end
end
