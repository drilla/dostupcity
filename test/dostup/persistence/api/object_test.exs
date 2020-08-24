defmodule Dostup.Persistence.Api.ObjectTest do
  use Dostup.DataCase, async: true

  alias Dostup.Persistence.Api.Object, as: Api

  import Dostup.Support.Db.Objects

  test "list and insert"  do
    assert %Scrivener.Page{total_entries: 0} = Api.list()

    district = add_district()
    type = add_type()

    Api.add(%{
      name: "test",
      short_name: "te",
      address: "adddddressss",
      ymap_url: "this is url",
      district: district,
      type: type
    })

    assert %Scrivener.Page{total_entries: 1} = Api.list()
  end
end
