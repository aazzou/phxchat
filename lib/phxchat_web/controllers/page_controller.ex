defmodule PhxChatWeb.PageController do
  use PhxChatWeb, :controller
  require Logger


  alias PhxChat.Chat
  alias PhxChat.Repo

  def index(conn, _params) do
    user = conn.assigns.current_user
      |> Repo.preload(:contacts)
      |> Repo.preload(:conversations)

    render(conn, "index.html", user: user )
  end

  def add_contact(conn, _params) do
    render(conn, "add_contact.html", changeset: Chat.contact_changeset(%Chat.Contact{}) )
  end

  def create_contact(conn, %{"contact" => contact_params}) do
    case Chat.add_contact(conn.assigns.current_user, contact_params) do
      {:ok, _contact} ->
        conn
          |> put_flash(:info, "Contact created successfully.")
          |> redirect(to: "/")
      {:error, _} ->
        conn
          |> put_flash(:error, "Something wrong occured!")
          |> render("add_contact.html", changeset: Chat.contact_changeset(%Chat.Contact{}) )
    end
  end

  def create_or_redirect(conn, %{"id" => id}) do
    try do
      user_id = conn.assigns.current_user.id
      contact = Chat.get_contact(id)

      if (contact.user_id != user_id), do: raise "NotFound"

      {:ok, conversation} = Chat.get_or_create_conversation(conn.assigns.current_user, contact)

      conn |> redirect(to: "/chat/#{conversation.uuid}")
    rescue
      e ->
        IO.inspect e
        conn |> redirect(to: "/")
    end
  end
end
