defmodule Dostup.Schemas.ObjectType do
  use Ecto.Schema
  import Ecto.Changeset


  use Dostup.Services.Serializer.Fields, %{
    id: [:show, :list],
    name: [:show, :list]
  }

  schema "object_types" do
    field(:name, :string, size: 255)
  end

  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params) do
   %__MODULE__{}
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
