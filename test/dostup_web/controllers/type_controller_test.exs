defmodule Dostup.TypeControllerTest do
  use Dostup.ConnCase, async: true

  alias Dostup.Persistence.Api.ObjectTypes, as: Api

  import Dostup.Support.Db.Users
  import Dostup.Support.Db.Objects

  @endpoint DostupWeb.TypeController

  setup do
    {:ok, %{ conn: build_conn()}}
  end

  test "list", %{conn: conn} do
    add_type()
    get(conn, :index)
    |> assert_count(1)
  end

  test "show", %{conn: conn} do
    %{id: id} = add_type("sdf@sdfsdf.ru")
    res = json_response( get(conn, :show, %{"id" => id}), 200)
    assert %{"id" => id} = res
  end

  defp assert_count(conn, count) do
    assert list = json_response(conn, 200)
    assert is_list(list)
    assert Enum.count(list) == count
  end

  defp assigned?(obj, user) do
    obj.user_id == user.id
  end
end
