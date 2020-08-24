defmodule Dostup.Interactor.Objects do
  alias Dostup.Persistence.Api.Object, as: Api
  alias Dostup.Schemas.{Object, User}

  def assign(id, user) do
    case Api.get(id) do
      %Object{user: nil} = object ->
        Api.assign_to_user(object, user)

      %Object{user: _} ->
        {:error, :already_assigned}

      _ ->
        {:error, :not_found}
    end
  end

  def unassign(id, %User{id: user_id} = _user) do
    case Api.get(id) do
      %Object{user: %User{id: ^user_id}} = object ->
        Api.assign_to_user(object, nil)

      _ ->
        {:error, :not_found}
    end
  end

  @spec uncheck(integer, User.t()) ::
          {:error, :already_unchecked | :not_found | :not_owner | Ecto.Changeset.t()}
          | {:ok, Object.t()}
  def uncheck(id, %User{} = user) do
    object = Api.get(id)

    if Api.is_owner?(user, object) do
      uncheck_object(object)
    else
      {:error, :not_owner}
    end
  end

  @spec check(integer, User.t()) ::
          {:error, :already_checked | :not_found | :not_owner | Ecto.Changeset.t()}
          | {:ok, Object.t()}
  def check(id, %User{} = user) do
    object = Api.get(id)

    if Api.is_owner?(user, object) do
      check_object(object)
    else
      {:error, :not_owner}
    end
  end

  defp uncheck_object(%Object{is_checked: true} = object), do: Api.uncheck(object)
  defp uncheck_object(%Object{is_checked: false}), do: {:error, :already_unchecked}

  defp check_object(%Object{is_checked: false} = object), do: Api.check(object)
  defp check_object(%Object{is_checked: true}), do: {:error, :already_checked}
end
