defmodule Dostup.Services.Csv.ObjectLoader do
  alias Dostup.Persistence.Api.Object, as: ObjectApi
  alias Dostup.Persistence.Api.ObjectTypes, as: TypeApi
  alias Dostup.Persistence.Api.District, as: DistrictApi
  alias Dostup.Persistence.Api.City, as: CityApi
  alias Dostup.Persistence.Repo

  require Logger

  @spec load!(String.t()) :: :ok | no_return()
  def load!(file_path) do
    file_path
    |> File.stream!()
    |> CSV.decode(separator: ?;, headers: true, strip_fields: true)
    |> Enum.each(&parse_row/1)
  end

  defp parse_row(row) do
    Repo.transaction(fn ->
      with {:ok, city} <- get_or_create_city(row),
           {:ok, district} <- get_or_create_district(city, row),
           {:ok, type} <- get_or_create_type(row),
           {:ok, object} <- get_or_create_object(district, type, row),
           object do
      else
        {:error, error} ->
          Logger.error(inspect(error))
          Repo.rollback(error)
          error

        error1 ->
          Logger.error(inspect(error1))
          error = {:error, "unknown error"}
          Repo.rollback(error)
      end
    end)
  end

  defp get_or_create_city({:ok, %{"Город" => name}}) do
    case CityApi.get_by_name(name) do
      nil ->
        CityApi.add(name)

      city ->
        {:ok, city}
    end
  end

  defp get_or_create_district(city, {:ok, %{"Район" => name}}) do
    case DistrictApi.get(city, name) do
      nil ->
        DistrictApi.add(name, city)

      district ->
        {:ok, district}
    end
  end

  def get_or_create_type({:ok, %{"Тип объекта" => type_str}}) do
    case TypeApi.get_by_name(type_str) do
      nil ->
        TypeApi.add(type_str)

      type ->
        {:ok, type}
    end
  end

  defp get_or_create_object(
         district,
         type,
         {:ok,
          %{
            "Адрес объекта" => address,
            "Короткое название объекта" => short_name,
            "Основное название объекта" => name,
            "Ссылка на объект" => ymap_url
          }}
       ) do
    case ObjectApi.find_in_district(address, name, district) do
      nil ->
        res = ObjectApi.add(%{
          name: name,
          short_name: short_name,
          address: address,
          ymap_url: ymap_url,
          type: type,
          district: district
       })
       Logger.debug(".")
       res


      existing_object ->
        Logger.debug("E")
        {:ok, existing_object}
    end
  end
end
