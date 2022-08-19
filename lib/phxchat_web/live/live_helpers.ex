defmodule PhxChatWeb.LiveHelpers do
  import  Phoenix.LiveView.Helpers

  require Logger

  alias   PhxChat.Accounts.User
  alias   PhxChat.Accounts

  def find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end

  def show_message(assigns) do
    cond do
      owned?(assigns) ->
        ~H"""
          <li class="flex justify-end"><div class="relative max-w-xl px-4 py-2 text-gray-700 bg-gray-100 rounded shadow"><span class="block"><%= Phoenix.HTML.raw assigns.message.text %></span></div></li>
        """
      true ->
        ~H"""
          <li class="flex justify-start"><div class="relative max-w-xl px-4 py-2 text-gray-700 rounded shadow"><span class="block a:underline"><%= Phoenix.HTML.raw assigns.message.text %></span></div></li>
        """
    end
  end

  defp owned?(assigns) do
    assigns.message.user_id == assigns.current_user.id
  end
end
