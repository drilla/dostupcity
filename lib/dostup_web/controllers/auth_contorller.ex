defmodule DostupWeb.AuthController do
  use DostupWeb, :controller

  alias Dostup.Schemas.User
  alias Dostup.Persistence.Api.User, as: Api
  alias DostupWeb.Auth.Token

  def login(conn, params) do
    login = params["login"]
    password = params["password"]

    user = Api.get(login, password)

    case user do
      nil     ->
        conn
        |> put_view(DostupWeb.ErrorView)
        |> put_status(401)
        |> render("login_not_successful.json", %{})
      %User{id: user_id} ->
        token = Token.generate_and_sign!(%{"user_id" => user_id})
        json(conn, %{token: token})
    end
  end
end
