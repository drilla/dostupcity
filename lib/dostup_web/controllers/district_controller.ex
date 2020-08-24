defmodule DostupWeb.DistrictController do
  use DostupWeb, :controller

  alias Dostup.Persistence.Api.District, as: Api
  alias Dostup.Schemas.District

  import Dostup.Services.Serializer.GroupFieldEncoder, only: [wrap: 2]

  def index(conn, %{"city_id" => city_id}) do
    list = Api.get_by_city(city_id)
    json(conn, list |> wrap([:list]))
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    object = Api.get(id)

    case object do
      %District{} ->
        json(conn, object |> wrap([:show]))

      nil ->
        conn
        |> put_status(404)
        |> put_view(DostupWeb.ErrorView)
        |> render("404.json")
    end
  end
end
