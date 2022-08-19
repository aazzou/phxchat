defmodule PhxChatWeb.ConversationLiveTest do
  use PhxChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhxChat.ChatFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_conversation(_) do
    conversation = conversation_fixture()
    %{conversation: conversation}
  end

  describe "Index" do
    setup [:create_conversation]

    test "lists all conversations", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.conversation_index_path(conn, :index))

      assert html =~ "Listing Conversations"
    end

    test "saves new conversation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.conversation_index_path(conn, :index))

      assert index_live |> element("a", "New Conversation") |> render_click() =~
               "New Conversation"

      assert_patch(index_live, Routes.conversation_index_path(conn, :new))

      assert index_live
             |> form("#conversation-form", conversation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#conversation-form", conversation: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.conversation_index_path(conn, :index))

      assert html =~ "Conversation created successfully"
    end

    test "updates conversation in listing", %{conn: conn, conversation: conversation} do
      {:ok, index_live, _html} = live(conn, Routes.conversation_index_path(conn, :index))

      assert index_live |> element("#conversation-#{conversation.id} a", "Edit") |> render_click() =~
               "Edit Conversation"

      assert_patch(index_live, Routes.conversation_index_path(conn, :edit, conversation))

      assert index_live
             |> form("#conversation-form", conversation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#conversation-form", conversation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.conversation_index_path(conn, :index))

      assert html =~ "Conversation updated successfully"
    end

    test "deletes conversation in listing", %{conn: conn, conversation: conversation} do
      {:ok, index_live, _html} = live(conn, Routes.conversation_index_path(conn, :index))

      assert index_live |> element("#conversation-#{conversation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#conversation-#{conversation.id}")
    end
  end

  describe "Show" do
    setup [:create_conversation]

    test "displays conversation", %{conn: conn, conversation: conversation} do
      {:ok, _show_live, html} = live(conn, Routes.conversation_show_path(conn, :show, conversation))

      assert html =~ "Show Conversation"
    end

    test "updates conversation within modal", %{conn: conn, conversation: conversation} do
      {:ok, show_live, _html} = live(conn, Routes.conversation_show_path(conn, :show, conversation))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Conversation"

      assert_patch(show_live, Routes.conversation_show_path(conn, :edit, conversation))

      assert show_live
             |> form("#conversation-form", conversation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#conversation-form", conversation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.conversation_show_path(conn, :show, conversation))

      assert html =~ "Conversation updated successfully"
    end
  end
end
