defmodule PhxChatWeb.ContactLiveTest do
  use PhxChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhxChat.ChatFixtures

  @create_attrs %{account_id: "some account_id", username: "some username"}
  @update_attrs %{account_id: "some updated account_id", username: "some updated username"}
  @invalid_attrs %{account_id: nil, username: nil}

  defp create_contact(_) do
    contact = contact_fixture()
    %{contact: contact}
  end

  describe "Index" do
    setup [:create_contact]

    test "lists all contacts", %{conn: conn, contact: contact} do
      {:ok, _index_live, html} = live(conn, Routes.contact_index_path(conn, :index))

      assert html =~ "Listing Contacts"
      assert html =~ contact.account_id
    end

    test "saves new contact", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.contact_index_path(conn, :index))

      assert index_live |> element("a", "New Contact") |> render_click() =~
               "New Contact"

      assert_patch(index_live, Routes.contact_index_path(conn, :new))

      assert index_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#contact-form", contact: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contact_index_path(conn, :index))

      assert html =~ "Contact created successfully"
      assert html =~ "some account_id"
    end

    test "updates contact in listing", %{conn: conn, contact: contact} do
      {:ok, index_live, _html} = live(conn, Routes.contact_index_path(conn, :index))

      assert index_live |> element("#contact-#{contact.id} a", "Edit") |> render_click() =~
               "Edit Contact"

      assert_patch(index_live, Routes.contact_index_path(conn, :edit, contact))

      assert index_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#contact-form", contact: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contact_index_path(conn, :index))

      assert html =~ "Contact updated successfully"
      assert html =~ "some updated account_id"
    end

    test "deletes contact in listing", %{conn: conn, contact: contact} do
      {:ok, index_live, _html} = live(conn, Routes.contact_index_path(conn, :index))

      assert index_live |> element("#contact-#{contact.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#contact-#{contact.id}")
    end
  end

  describe "Show" do
    setup [:create_contact]

    test "displays contact", %{conn: conn, contact: contact} do
      {:ok, _show_live, html} = live(conn, Routes.contact_show_path(conn, :show, contact))

      assert html =~ "Show Contact"
      assert html =~ contact.account_id
    end

    test "updates contact within modal", %{conn: conn, contact: contact} do
      {:ok, show_live, _html} = live(conn, Routes.contact_show_path(conn, :show, contact))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Contact"

      assert_patch(show_live, Routes.contact_show_path(conn, :edit, contact))

      assert show_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#contact-form", contact: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.contact_show_path(conn, :show, contact))

      assert html =~ "Contact updated successfully"
      assert html =~ "some updated account_id"
    end
  end
end
