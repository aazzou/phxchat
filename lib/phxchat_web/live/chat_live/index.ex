defmodule PhxChatWeb.ChatLive.Index do
  use PhxChatWeb, :live_view
  require Logger
  alias PhxChat.Repo
  alias PhxChat.Chat

  @impl true
  def mount(%{"uuid" => uuid}, session, socket) do
    user = find_current_user(session)
    conversation = user.conversations
                      |> Enum.filter( fn c -> c.uuid == uuid end )
                      |> Enum.at(0)
                      |> Repo.preload(:messages)

    topic = "conversation-#{conversation.id}"
    if connected?(socket), do: Chat.subscribe(topic)

    { :ok,
      socket
      |> assign(:current_user, user)
      |> assign(:conversation, conversation)
      |> assign(:messages, conversation.messages)
      |> assign(:topic, topic) }
  end

  @impl true
  def handle_event("submit_message", %{"message" => message}, socket) do
    message
    |> Map.put("user_id", socket.assigns.current_user.id)
    |> Map.put("text", update_links(message["text"]) )
    |> Chat.create_message()
    {:noreply, socket}
  end

  @impl true
  def handle_info({:message_created, message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message]) }
  end

  defp update_links(text ) do
    Regex.replace(~r|([\w+]+\:\/\/)?([\w\d-]+\.)*[\w-]+[\.\:]\w+([\/\?\=\&\#\.]?[\w-]+)*\/?|, text, "<a class='underline text-indigo-600' href='\\0' target='_blank'>\\0</a>")
  end
end
