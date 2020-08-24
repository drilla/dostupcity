defmodule Dostup.Schemas.District do

  use Ecto.Schema

  import Ecto.Changeset

  alias Dostup.Schemas.City

  use Dostup.Services.Serializer.Fields, %{
    id: [:show, :list],
    city: [:show, :list],
    name: [:show, :list]
  }

  schema "districts" do
    field(:name, :string, size: 255)
    belongs_to(:city, City)
  end

  @spec changeset_new(
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any},
          Dostup.Schemas.City.t()
        ) :: Ecto.Changeset.t()
  def changeset_new(params, %City{} = city)  do
    %__MODULE__{}
    |> cast(params, [:name])
    |> validate_required([:name])
    |> put_assoc(:city, city)
  end
end
