defmodule Dostup.Support.Db.Users do

  import Dostup.Support.Db.Objects

  require Logger

  alias Dostup.Schemas.{User, Role, Permission}
  alias Dostup.Persistence.Api.User, as: Api
  alias Dostup.Persistence.Api.Role, as: RoleApi
  alias Dostup.Persistence.Api.Permission, as: PermissionApi
  alias Dostup.Persistence.RepoMaster, as: Repo

  def register_user(district, login \\ "test@dobro.ru", password \\ "12445433", fio \\ "Иванов Иван Петрович", age \\ 33) do
    Api.register(district, login, password, fio, age) |> result_or_error()
  end

  def add_user(email \\ "test@dobro.ru", password \\ "1234567890") do
    district = add_district()
    register_user(district, email, password)
  end

  defp result_or_error({:ok, result}), do: result
  defp result_or_error(error) do
    Logger.error(inspect(error))
   :error
  end
end
