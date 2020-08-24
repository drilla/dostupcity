defmodule Dostup.Persistence.Api.CityTest do
  use Dostup.DataCase, async: false

  alias Dostup.Persistence.Api.City, as: Api

  import Dostup.Support.Db.Objects


  test "list and insert"  do
    assert Enum.count(Api.all()) == 0

    Api.add("test")

    assert Enum.count(Api.all()) == 1
  end
end
