defmodule Dostup.Interactor.Users do
  alias Dostup.Schemas.User
  alias Dostup.Schemas.District
  alias Dostup.Persistence.Api.User, as: UserApi
  alias Dostup.Persistence.Api.District, as: DistrictApi
  alias Dostup.Services.Password
  alias Dostup.Persistence.Repo
  alias Dostup.Services.Email.Sender
  alias Dostup.Services.Email.Mailer

  require Logger

  # @todo добавить тест на проверку транзакции
  def register_or_error(%{
        "login" => login,
        "fio" => fio,
        "age" => age,
        "district_id" => district_id
      }) do
    case DistrictApi.get(district_id) do
      nil ->
        {:error, "district not found"}

      %District{} = district ->
        Repo.transaction(fn ->
          with {{:ok, user}, password} <- register_user(district, login, fio, age),
               :ok <- send_register_email(user, password) do
            {:ok, user}
          else
            error ->
              Logger.error(inspect(error))
              Repo.rollback(error)
          end
        end)
        |> case do
          {:ok, v} -> v
          {:error, e} -> e
        end
    end
  end

  defp register_user(district, login, fio, age) do
    pass = Password.generate_human(8)
    result = UserApi.register(district, login, pass, fio, age)

    case result do
      {:ok, _} -> {result, pass}
      _ -> result
    end
  end

  @spec restore_password(String.t()) :: {:ok} | {:error, :not_found | Ecto.Changeset.t()}
  def restore_password(login) do
    case user = UserApi.get_by_login(login) do
      %User{} ->
        create_new_password_and_send(user)

      nil ->
        {:error, :not_found}
    end
  end

  @spec create_new_password_and_send(User.t()) ::
          {:ok} | {:error, Ecto.Changeset.t()} | {:error, atom()}
  defp create_new_password_and_send(%User{} = user) do
    pass = Password.generate_human(8)

    case UserApi.update_password(user, pass) do
      {:ok, user} ->
        send_change_password_email(user, pass)
        {:ok}

      {:error, set} ->
        {:error, set}
    end
  end

  defp send_register_email(%User{} = user, password) do
    Mailer.new_registration_email(user |> IO.inspect(), password)
    |> Sender.send_now()
    |> log_on_error()

    :ok
  end

  defp send_change_password_email(%User{} = user, password) do
    Mailer.new_reset_password_email(user, password)
    |> Sender.send_now()
    |> log_on_error()

    :ok
  end

  defp log_on_error({:error, _} = result) do
    result
    |> inspect()
    |> Logger.error()

    result
  end

  defp log_on_error(result) do
    result
  end
end
