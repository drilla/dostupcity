defmodule Dostup.Schemas.City do
  use Ecto.Schema
  import Ecto.Changeset


  use Dostup.Services.Serializer.Fields, %{
    id: [:show, :list],
    name: [:show, :list]
  }

  schema "cities" do
    field(:name, :string, size: 255)
  end

  @spec changeset(Ecto.Changeset.t() | map(), map()) :: Ecto.Changeset.t()
  def changeset(model, params) do
    model
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def changeset_new(params) do
    changeset(%__MODULE__{}, params)
  end
end
