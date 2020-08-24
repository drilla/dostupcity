defmodule DostupWeb.TypeController do
  use DostupWeb, :controller
  alias Dostup.Persistence.Api.ObjectTypes, as: Api
  alias Dostup.Schemas.ObjectType

  import Dostup.Services.Serializer.GroupFieldEncoder, only: [wrap: 2]

  def index(conn, _params) do
    page = Api.all()
    json(conn, page |> wrap([:list]))
  end

  def show(conn, %{"id" => id}) do
    type = Api.get(id)

    case type do
      %ObjectType{} ->
        json(conn, type |> wrap([:show]))

      nil ->
        conn
        |> put_status(404)
        |> put_view(DostupWeb.ErrorView)
        |> render("404.json")
    end
  end
end
