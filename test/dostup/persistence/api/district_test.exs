defmodule Dostup.Persistence.Api.DistrictTest do
  use Dostup.DataCase, async: false

  alias Dostup.Persistence.Api.District, as: Api

  import Dostup.Support.Db.Objects


  test "list and insert"  do
    assert Enum.count(Api.all()) == 0

    city = add_city()

    Api.add("test", city)

    assert Enum.count(Api.all()) == 1
  end
end
