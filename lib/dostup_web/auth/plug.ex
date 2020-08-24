defmodule DostupWeb.Auth.Plug do
  import Plug.Conn
  require Logger

  alias DostupWeb.Auth.Token
  alias Dostup.Persistence.Api.User, as: UserApi

  def init(opts), do: opts

  def call(conn, _opts) do
    case jwt_from_header(conn) do
      nil ->
        Logger.debug("token not found in headers")
        forbidden(conn)

      token ->
        case Token.verify_and_validate(token) do
          {:ok, claims} ->
            success(conn, claims)

          {:error, reason} ->
            Logger.debug(inspect(reason))
            forbidden(conn)
        end
    end
  end

  defp jwt_from_header(conn) do
    conn |> get_req_header("jwt") |> List.first()
  end

  defp success(conn, token_payload) do
    usr =
      token_payload["user_id"]
      |> UserApi.get()

    conn
    |> assign(:claims, token_payload)
    |> assign(:jwt, token_payload["jti"])
    |> assign(:user, usr)
    |> put_status(200)
  end

  defp forbidden(conn) do
    conn
    |> put_status(401)
    |> Phoenix.Controller.put_view(DostupWeb.ErrorView)
    |> Phoenix.Controller.render("401.json")
    |> halt
  end
end
