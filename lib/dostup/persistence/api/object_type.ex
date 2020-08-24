defmodule Dostup.Persistence.Api.ObjectTypes do
  alias Dostup.Persistence.Repo
  alias Dostup.Schemas.ObjectType

  import Ecto.Query

  def get(id) do
    Repo.get(ObjectType, id)
  end

  def get_by_name(name) when is_binary(name) do
    Repo.get_by(ObjectType, [name: name])
  end
  @spec all() :: [ObjectType.t()]
  def all() do
    (from t in ObjectType)
    |> Repo.all()
  end

  def add(name) do
    ObjectType.changeset(%{name: name})
    |> Repo.insert()
  end
end
