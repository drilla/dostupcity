defmodule Dostup.Persistence.Api.District do
  alias Dostup.Persistence.Repo
  alias Dostup.Schemas.District, as: Schema
  alias Dostup.Schemas.City, as: CitySchema

  import Ecto.Query

  def get(id) do
    Repo.get(Schema, id)
    |> Repo.preload([:city])
  end

  def get_by_city(city_id) do
    (from s in Schema,
    where: s.city_id == ^city_id)
    |> Repo.all()
    |> Repo.preload([:city])
  end

  def get(%CitySchema{id: id}, name) do
    Repo.get_by(Schema, [city_id: id, name: name])
  end

  @spec all() :: [Schema.t()]
  def all() do
    (from t in Schema)
    |> Repo.all()
    |> Repo.preload([:city])
  end

  def add(name, city) do
    Schema.changeset_new(%{name: name}, city)
    |> Repo.insert()
  end
end
