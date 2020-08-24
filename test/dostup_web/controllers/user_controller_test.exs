defmodule Dostup.UserControllerTest do
  use Dostup.ConnCase, async: true

  alias Dostup.Persistence.Api.User, as: UserApi

  import Dostup.Support.Db.Users
  import Dostup.Support.Db.Objects

  @endpoint DostupWeb.UserController

  setup do
    {:ok, %{conn: build_conn()}}
  end

  test "register", %{conn: conn} do
    %{id: id} = add_district()

    conn =
      put(conn, :register, %{
        login: "exapmple@example.com",
        age: "22",
        fio: "mazzafakf",
        district_id: id
      })

    assert "ok" = json_response(conn, 200)
    assert UserApi.list(%{}).total_entries == 1
  end

  test "change pass", %{conn: conn} do
    user = add_user()
    %{id: id, login: login, password_hash: hash_before} = user

    conn =
      conn
      |> post(:restore_password, login: login)
      |> json_response(200)

    %{password_hash: hash_after} = UserApi.get(id)

    assert hash_before != hash_after
  end

  test "list", %{conn: conn} do
    city_one = add_city("1")
    city_two = add_city("2")
    district_one = add_district("one", city_one)
    district_two = add_district("two", city_two)
    register_user(district_one, "sdf@sdfsdf.ru")
    register_user(district_two, "sdddf@sdfsdf.ru")

    get(conn, :index, page: 1, page_: 10)
    |> assert_users(2)
  end

  test "total", %{conn: conn} do
    city_one = add_city("1")
    city_two = add_city("2")
    district_one = add_district("one", city_one)
    district_two = add_district("two", city_two)
    register_user(district_one, "sdf@sdfsdf.ru")
    register_user(district_two, "sdddf@sdfsdf.ru")

    assert 2 = get(conn, :total) |> json_response(200)
  end

  defp assert_users(conn, count) do
    assert %{"entries" => users} = json_response(conn, 200)
    assert is_list(users)
    assert Enum.count(users) == count
  end
end
