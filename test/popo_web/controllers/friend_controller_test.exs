defmodule PopoWeb.FriendControllerTest do
  use PopoWeb.ConnCase

  alias Popo.Friends

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:friend) do
    {:ok, friend} = Friends.create_friend(@create_attrs)
    friend
  end

  describe "index" do
    test "lists all friends", %{conn: conn} do
      conn = get(conn, Routes.friend_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Friends"
    end
  end

  describe "new friend" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.friend_path(conn, :new))
      assert html_response(conn, 200) =~ "New Friend"
    end
  end

  describe "create friend" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.friend_path(conn, :create), friend: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.friend_path(conn, :show, id)

      conn = get(conn, Routes.friend_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Friend"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.friend_path(conn, :create), friend: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Friend"
    end
  end

  describe "edit friend" do
    setup [:create_friend]

    test "renders form for editing chosen friend", %{conn: conn, friend: friend} do
      conn = get(conn, Routes.friend_path(conn, :edit, friend))
      assert html_response(conn, 200) =~ "Edit Friend"
    end
  end

  describe "update friend" do
    setup [:create_friend]

    test "redirects when data is valid", %{conn: conn, friend: friend} do
      conn = put(conn, Routes.friend_path(conn, :update, friend), friend: @update_attrs)
      assert redirected_to(conn) == Routes.friend_path(conn, :show, friend)

      conn = get(conn, Routes.friend_path(conn, :show, friend))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, friend: friend} do
      conn = put(conn, Routes.friend_path(conn, :update, friend), friend: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Friend"
    end
  end

  describe "delete friend" do
    setup [:create_friend]

    test "deletes chosen friend", %{conn: conn, friend: friend} do
      conn = delete(conn, Routes.friend_path(conn, :delete, friend))
      assert redirected_to(conn) == Routes.friend_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.friend_path(conn, :show, friend))
      end
    end
  end

  defp create_friend(_) do
    friend = fixture(:friend)
    {:ok, friend: friend}
  end
end
