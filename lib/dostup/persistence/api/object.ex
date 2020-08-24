defmodule Dostup.Persistence.Api.Object do
  alias Dostup.Persistence.Repo
  alias Dostup.Schemas.Object, as: ObjectSchema
  alias Dostup.Schemas.User

  import Ecto.Query

  @spec get(integer()) :: nil | ObjectSchema.t()
  def get(id) do
    Repo.get(ObjectSchema, id) |> preload
  end

  def find_in_district(address, name,  district) do
    Repo.get_by(ObjectSchema, [address: address, name: name,  district_id: district.id]) |> preload
  end

  @spec list(map()) :: Scrivener.Page.t()
  def list(params \\ %{}) do
    base_list()
    |> Repo.paginate(params)
  end

  def list_by_district(id) do
    base_list()
    |> where([t], t.district_id == ^id)
    |> Repo.all()
  end

  @spec list_by_user(User.t(),  map()) :: Scrivener.Page.t()
  def list_by_user(%User{id: id}, params) do
    base_list()
    |>  where([t], t.user_id == ^id)
    |> Repo.paginate(params)
  end

  @spec add(map()) :: {:ok, map()} | {:error, map()}
  def add(params) do
    ObjectSchema.changeset_new(params)
    |> Repo.insert()
  end

  @spec assign_to_user(ObjectSchema.t(), User.t() | nil) :: {:ok, ObjectSchema.t()} | {:error, Ecto.Changeset.t()}
  def assign_to_user(%ObjectSchema{} = object, user) do
    object = Repo.preload(object, :user)
    ObjectSchema.changeset_assign(object, user)
    |> Repo.update()
  end

  @spec check(ObjectSchema.t()) :: {:ok, ObjectSchema.t()} | {:error,Ecto.Changeset.t()}
  def check(%ObjectSchema{} = object) do
    object
    |> ObjectSchema.changeset_check()
    |> Repo.update()
  end

  @spec uncheck(ObjectSchema.t()) :: {:ok, ObjectSchema.t()} | {:error, Ecto.Changeset.t()}
  def uncheck(%ObjectSchema{} = object) do
    object
    |> ObjectSchema.changeset_check(false)
    |> Repo.update()
  end

  @spec is_owner?(User.t(), Object.t()) :: boolean
  def is_owner?(%User{id: user_id}, %ObjectSchema{user_id: obj_user_id}) when user_id == obj_user_id, do: true
  def is_owner?(%User{}, _), do: false


  @spec base_list() :: Ecto.Query.t()
  defp base_list() do
    from t in ObjectSchema,
    left_join: d in assoc(t, :district),
    on: t.district_id == d.id,
    left_join: c in assoc(d, :city),
    on: d.city_id == c.id,
    left_join: p in assoc(t, :type),
    on: t.type_id == p.id,
    left_join: u in assoc(t, :user),
    on: u.id == t.user_id,
    preload: [
      district: {d, city: c},
      type: p,
      user: u
    ]
  end

  defp preload(struct_or_structs) do
    Repo.preload(struct_or_structs, [district: [:city], type: [], user: []])
  end
end
