defmodule Dostup.DistrictControllerTest do
  use Dostup.ConnCase, async: true

  alias Dostup.Persistence.Api.ObjectTypes, as: Api

  import Dostup.Support.Db.Users
  import Dostup.Support.Db.Objects

  @endpoint DostupWeb.DistrictController

  setup do
    {:ok, %{ conn: build_conn()}}
  end

  test "list", %{conn: conn} do
    city = add_city()
    %{id: city_id} = city
    district = add_district("test", city)
    get(conn, :index, %{"city_id" => city_id})
    |> assert_count(1)
  end

  test "show", %{conn: conn} do
    %{id: id} = add_district()
    res = json_response( get(conn, :show, %{"id" => id}), 200)
    assert %{"id" => id} = res
  end

  defp assert_count(conn, count) do
    assert list = json_response(conn, 200)
    assert is_list(list)
    assert Enum.count(list) == count
  end
end
