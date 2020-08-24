defmodule Dostup.Schemas.Object do
  use Ecto.Schema

  import Ecto.Changeset

  alias Dostup.Schemas.District
  alias Dostup.Schemas.ObjectType
  alias Dostup.Schemas.User

  use Dostup.Services.Serializer.Fields, %{
    id: [:show, :list],
    name: [:show, :list],
    short_name: [:show, :list],
    address: [:show, :list],
    ymap_url: [:show, :list],
    district: [:show, :list],
    is_checked: [:show, :list],
    type: [:show, :list]
  }

  schema "objects" do
    field(:name, :string, size: 255)
    field(:ymap_url, :string, size: 255)
    field(:address, :string, size: 255)
    field(:short_name, :string, size: 255)
    field(:is_checked, :boolean)

    belongs_to(:district, District)
    belongs_to(:type, ObjectType)
    belongs_to(:user, User, on_replace: :nilify)
  end

  @spec changeset(Ecto.Changeset.t() | map(), map()) ::
          Ecto.Changeset.t()
  defp changeset(model, %{district: district, type: type} = params) do
    model
    |> cast(params, [:name, :ymap_url, :address, :short_name])
    |> validate_required([:name, :ymap_url, :address, :short_name])
    |> put_assoc(:district, district)
    |> put_assoc(:type, type)
  end

  @spec changeset_new(map()) :: Ecto.Changeset.t()
  def changeset_new(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  def changeset_assign(%__MODULE__{} = obj, user) do
    obj
    |> change()
    |> put_assoc(:user, user)
  end

  @spec changeset_check(Object.t(), boolean()) :: Ecto.Changeset.t()
  def changeset_check(%__MODULE__{} = obj, is_checked \\ true) do
    obj
    |> change()
    |> put_change(:is_checked, is_checked)
  end
end
