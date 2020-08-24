defmodule Dostup.Support.Db.Objects do

  alias Dostup.Schemas.{City, District, Object, ObjectType}
  alias Dostup.Persistence.Api.Object, as: ObjectApi
  alias Dostup.Persistence.Api.ObjectTypes, as: ObjectTypesApi
  alias Dostup.Persistence.Api.City, as: CityApi
  alias Dostup.Persistence.Api.District, as: DistrictApi
  alias Dostup.Persistence.RepoMaster, as: Repo

  require Logger

  def add_city(name \\ "test city") do
    CityApi.add(name) |> result_or_error()
  end

#  def add_district(name \\ "test district")

  def add_district(name \\ "test district") do
    add_district(name, add_city())
  end

  def add_district(name, city) do
    DistrictApi.add(name, city) |> result_or_error()
  end

  def add_type(name \\ "test type") do
    ObjectTypesApi.add(name) |> result_or_error()
  end

  def assign_to_user(user, object) do
    ObjectApi.assign_to_user(object, user) |> result_or_error()
  end

  def check(object) do
    ObjectApi.check(object) |> result_or_error()
  end

  def add_object(name \\ "test_obj") do
    district = add_district()
    type = add_type()
    ObjectApi.add(%{
      name: "test",
      short_name: "test",
      address: "city addr",
      ymap_url: "http://test",
      district: district,
      type: type
    })
    |> result_or_error()
  end

  def add_object_long(city_name, district_name, name) do
    city = add_city(city_name)
    district = add_district(district_name, city)
    type = add_type()
    ObjectApi.add(%{
      name: name,
      short_name: name,
      address: "city addr",
      ymap_url: "http://test",
      district: district,
      type: type
    })
    |> result_or_error()
  end
  defp result_or_error({:ok, result}), do: result
  defp result_or_error(error) do
    Logger.error(inspect(error))
   :error
  end
end
