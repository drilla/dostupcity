defmodule DostupWeb.UserController do
  use DostupWeb, :controller

  alias Dostup.Persistence.Api.User, as: Api
  alias Dostup.Schemas.User
  alias Dostup.Interactor.Users, as: UserInteractor

  import Dostup.Services.Serializer.GroupFieldEncoder, only: [wrap: 2]

  def me(%{assigns: %{user: %{id: user_id}}} = conn, _params) do
    user = Api.get(user_id)
    json(conn, wrap(user, [:show]))
  end

  def index(conn, params) do
    page = Api.list(params, [])
    json(conn, page |> wrap([:list]))
  end

  def total(conn, _params) do
    json(conn, Api.count())
  end

  def show(conn, %{"id" => id}) do
    user = Api.get(id)

    case user do
      %User{} ->
        json(conn, user |> wrap([:show]))

      nil ->
        conn
        |> put_status(404)
        |> put_view(DostupWeb.ErrorView)
        |> render("404.json")
    end
  end

  def register(conn, params) do
    case UserInteractor.register_or_error(params) do
      {:ok, _} ->
        json(conn, :ok)

      {:error, reason} ->
        conn
        |> put_status(200)
        |> put_view(DostupWeb.ErrorView)
        |> assign(:error, reason)
        |> render("error_with_detail.json")
    end
  end

  def restore_password(conn, %{"login" => login}) do

    UserInteractor.restore_password(login)
    |> render_result_change(conn)
  end

  defp render_result_change({:ok}, conn) do
    json(conn, :ok)
  end

  defp render_result_change({:error, %Ecto.Changeset{} = set}, conn) do
    conn
    |> put_status(400)
    json(conn, set |> wrap([:show]))
  end

  defp render_result_change({:error, :not_found}, conn) do
    conn
    |> put_status(401)
    |> put_view(DostupWeb.ErrorView)
    |> render("401.json")
  end

  defp render_result_change({:error, reason}, conn) do
    conn
    |> put_status(400)
    |> put_view(DostupWeb.ErrorView)
    |> assign(:error, reason)
    |> render("error_with_detail.json")
  end
end
