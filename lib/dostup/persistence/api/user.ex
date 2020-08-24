defmodule Dostup.Persistence.Api.User do
  alias Dostup.Persistence.Repo
  alias Dostup.Schemas.User
  alias Dostup.Schemas.District
  alias Dostup.Services.Password

  import Ecto.Query, except: [preload: 2]

  require Logger

  def get(id) do
    Repo.get(User, id) |> Repo.preload([district: [:city]])
  end

  @spec get(integer | String.t(), String.t()) :: User.t() | nil
  def get(login, password) do
    Repo.get_by(User, email: login, password_hash: Password.hash(password))|> Repo.preload([district: [:city]])
  end

  @spec get(String.t()) :: User.t() | nil
  def get_by_login(login) do
    Repo.get_by(User, email: login) |> Repo.preload([district: [:city]])
  end

  def update(user) do
    Repo.update(user)
  end

  @spec list(keyword | map) :: Scrivener.Page.t()
  def list(params, filters \\ []) do
    (from u in User,
    preload: [district: [:city]])
    |> filter(filters)
    |> Repo.paginate(params)
  end

  def count() do
    (from u in User,
    select: count(u)
    )
    |> Repo.one()
  end

  @spec register(Ecto.Changeset.t()) :: {:ok, User.t()} | {:error, String.t()}
  def register(changeset = %Ecto.Changeset{}) do
    Repo.insert(changeset)
  end

  @spec register(District.t(), String.t(), String.t(),  String.t(), integer()) ::
          {:ok, User.t()} | {:error, String.t()}
  def register(%District{id: id}, login, password, fio, age) do
    User.registration_changeset(%{
      login: login,
      password: password,
      fio: fio,
      age: age,
      district_id: id
    })
    |> Repo.insert()
  end

  @spec update_password(User.t(), String.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_password(%User{} = user, pass) do
    User.update_password_changeset(user, pass)
    |> Repo.update()
  end

  defp filter(q, []), do: q

  defp filter(q, [{_, _} | filters]), do: filter(q, filters)
end
