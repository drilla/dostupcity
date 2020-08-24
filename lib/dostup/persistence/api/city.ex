defmodule Dostup.Persistence.Api.City do
  alias Dostup.Persistence.Repo
  alias Dostup.Schemas.City, as: CitySchema

  import Ecto.Query

  def get(id) do
    Repo.get(CitySchema, id)
  end

  def get_by_name(name) do
    Repo.get_by(CitySchema, [name: name])
  end

  @spec all() :: [CitySchema.t()]
  def all() do
    (from t in CitySchema)
    |> Repo.all()
  end

  def add(name) do
    CitySchema.changeset_new(%{name: name})
    |> Repo.insert()
  end
end
