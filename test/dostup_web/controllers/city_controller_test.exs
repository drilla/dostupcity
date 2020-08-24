defmodule Dostup.CityControllerTest do
  use Dostup.ConnCase, async: true

  alias Dostup.Persistence.Api.City, as: Api

  import Dostup.Support.Db.Objects

  @endpoint DostupWeb.CityController

  setup do
    {:ok, %{ conn: build_conn()}}
  end

  test "list", %{conn: conn} do
    city = add_city()
    get(conn, :index)
    |> assert_count(1)
  end

  test "show", %{conn: conn} do
    %{id: id} = add_city()
    res = json_response( get(conn, :show, %{"id" => id}), 200)
    assert %{"id" => id} = res
  end

  defp assert_count(conn, count) do
    assert list = json_response(conn, 200)
    assert is_list(list)
    assert Enum.count(list) == count
  end
end
