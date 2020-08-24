defmodule DostupWeb.ObjectController do
  use DostupWeb, :controller

  alias Dostup.Persistence.Api.Object, as: Api
  alias Dostup.Schemas.User
  alias Dostup.Schemas.Object
  alias Dostup.Interactor.Objects, as: ObjectsInteractor

  import Dostup.Services.Serializer.GroupFieldEncoder, only: [wrap: 2]

  def index(conn, params) do
    page = Api.list(params)
    json(conn, page |> wrap([:list]))
  end

  def my(%Plug.Conn{assigns: %{user: %User{} = user}} = conn, params) do
    page = Api.list_by_user(user, params)
    json(conn, page |> wrap([:list]))
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    object = Api.get(id)

    case object do
      %Object{} ->
        json(conn, object |> wrap([:show]))

      nil ->
        conn
        |> put_status(404)
        |> put_view(DostupWeb.ErrorView)
        |> render("404.json")
    end
  end

  @spec assign(any, map) :: any
  def assign(%Plug.Conn{assigns: %{user: %User{} = user}} = conn, %{"id" => id}) do
    case ObjectsInteractor.assign(id, user) do
      {:ok, _object} ->
        json(conn, %{success: true})

      {:error, _reason} ->
        conn
        |> put_status(400)
        |> put_view(DostupWeb.ErrorView)
        |> render("400.json")
    end
  end

  def unassign(%Plug.Conn{assigns: %{user: %User{} = user}} = conn, %{"id" => id}) do
    case ObjectsInteractor.unassign(id, user) do
      {:ok, _object} ->
        json(conn, %{success: true})

      {:error, _reason} ->
        conn
        |> put_status(400)
        |> put_view(DostupWeb.ErrorView)
        |> render("400.json")
    end
  end

  def check(%Plug.Conn{assigns: %{user: %User{} = user}} = conn, %{"id" => id}) do
    case ObjectsInteractor.check(id, user) do
      {:ok, _object} ->
        json(conn, %{success: true})

      {:error, :not_owner} ->
        conn
        |> put_status(403)
        |> put_view(DostupWeb.ErrorView)
        |> render("403.json")

      {:error, :already_checked} ->
        conn
        |> put_status(400)
        |> assign(:error, "already checked")
        |> put_view(DostupWeb.ErrorView)
        |> render("error_with_detail.json")

      {:error, %Ecto.Changeset{} = set} ->
        conn
        |> put_status(400)
        |> json(set)
    end
  end

  def uncheck(%Plug.Conn{assigns: %{user: %User{} = user}} = conn, %{"id" => id}) do
    case ObjectsInteractor.uncheck(id, user) do
      {:ok, _object} ->
        json(conn, %{success: true})

      {:error, :not_owner} ->
        conn
        |> put_status(403)
        |> put_view(DostupWeb.ErrorView)
        |> render("403.json")

      {:error, :already_unchecked} ->
        conn
        |> put_status(400)
        |> assign(:error, "already unchecked")
        |> put_view(DostupWeb.ErrorView)
        |> render("error_with_detail.json")

      {:error, %Ecto.Changeset{} = set} ->
        conn
        |> put_status(400)
        |> json(set)
    end
  end

  def get_by_user_district(
        %Plug.Conn{assigns: %{user: %User{district_id: district_id}}} = conn,
        _params
      ) do
    list = Api.list_by_district(district_id)
    json(conn, list |> wrap([:list]))
  end

  @spec update(Plug.Conn.t(), any) :: Plug.Conn.t()
  def update(conn, _params) do
    conn
    |> put_status(403)
    |> put_view(DostupWeb.ErrorView)
    |> render("403.json")
  end
end
