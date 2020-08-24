defmodule DostupWeb.CityController do
  use DostupWeb, :controller

  alias Dostup.Persistence.Api.City, as: Api
  alias Dostup.Schemas.City

  import Dostup.Services.Serializer.GroupFieldEncoder, only: [wrap: 2]

  def index(conn, _params) do
    list = Api.all()
    json(conn, list |> wrap([:list]))
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    object = Api.get(id)

    case object do
      %City{} ->
        json(conn, object |> wrap([:show]))

      nil ->
        conn
        |> put_status(404)
        |> put_view(DostupWeb.ErrorView)
        |> render("404.json")
    end
  end
end
