defmodule Dostup.ObjectControllerTest do
  use Dostup.ConnCase, async: true

  alias Dostup.Persistence.Api.User, as: UserApi
  alias Dostup.Persistence.Api.Object, as: ObjectApi

  import Dostup.Support.Db.Users
  import Dostup.Support.Db.Objects

  @endpoint DostupWeb.ObjectController

  setup do
    city = add_city("tttt")
    district = add_district("ddd", city)
    user = register_user(district, "sdfdsf@sdf.ru", "123123123", "fio", 33)
    {:ok, %{conn: build_conn(), user: user}}
  end

  test "list", %{conn: conn} do
    add_object("sdf@sdfsdf.ru")

    get(conn, :index, page: 1, on_page: 10)
    |> assert_count(1)
  end

  test "my", %{conn: conn, user: user} do
    conn = assign(conn, :user, user)

    object = add_object("sdf@sdfsdf.ru")

    assert %{total_entries: 0} = ObjectApi.list_by_user(user, [])

    assign_to_user(user, object)

    get(conn, :my, page: 1, on_page: 10)
    |> assert_count(1)
  end

  test "show", %{conn: conn} do
    %{id: id} = add_object("sdf@sdfsdf.ru")
    conn = get(conn, :show, %{"id" => id})
    assert %{"id" => id} = json_response(conn, 200)
  end

  test "assign", %{conn: conn, user: user} do
    obj = add_object_long("tcity", "tdistict", "test name1")

    conn
    |> assign(:user, user)
    |> get(:assign, id: obj.id)
    |> json_response(200)
    |> assert()

    ObjectApi.get(obj.id)
    |> assigned?(user)
    |> assert()
  end

  test "check", %{conn: conn, user: user} do
    obj = add_object_long("tcity", "tdistict", "test name1")

    assign_to_user(user, obj)

    conn
    |> assign(:user, user)
    |> get(:check, id: obj.id)
    |> json_response(200)
    |> assert()

    obj = ObjectApi.get(obj.id)

    assert obj.is_checked()
  end

  test "check not own", %{conn: conn, user: user} do
    add_object_long("tcity", "tdistict", "test name1")

    # skip assigning
    conn
    |> assign(:user, user)
    |> get(:check, id: 0)
    |> json_response(403)
    |> assert()
  end

  test "uncheck", %{conn: conn, user: user} do
    obj = add_object_long("tcity", "tdistict", "test name1")
    assign_to_user(user, obj)
    check(obj)

    conn
    |> assign(:user, user)
    |> get(:uncheck, id: obj.id)
    |> json_response(200)
    |> assert()

    obj = ObjectApi.get(obj.id)

    refute obj.is_checked
  end

  test "uncheck not own", %{conn: conn, user: user} do
    add_object_long("tcity", "tdistict", "test name1")

    # skip assigning
    conn
    |> assign(:user, user)
    |> get(:uncheck, id: 0)
    |> json_response(403)
    |> assert()
  end

  test "unchecked error", %{conn: conn, user: user} do
    obj = add_object_long("tcity", "tdistict", "test name1")
    assign_to_user(user, obj)

    conn
    |> assign(:user, user)
    |> get(:uncheck, id: obj.id)
    |> json_response(400)
    |> assert()

    obj = ObjectApi.get(obj.id)

    refute obj.is_checked
  end
  defp assert_count(conn, count) do
    assert %{"entries" => list} = json_response(conn, 200)
    assert is_list(list)
    assert Enum.count(list) == count
  end

  defp assigned?(obj, user) do
    obj.user_id == user.id
  end
end
