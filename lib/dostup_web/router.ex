defmodule DostupWeb.Router do
  use DostupWeb, :router

  pipeline :auth do
    plug(DostupWeb.Auth.Plug)
  end

  pipeline :api do
    plug(DostupWeb.Auth.Plug)
    plug(:accepts, ["json"])
  end

  pipeline :api_unauthorized do
    plug(:accepts, ["json"])
  end

  scope "/cert", DostupWeb do
    pipe_through(:auth)
    get("/", CertController, :get)
  end

  scope "/api/login", DostupWeb do
    pipe_through(:api_unauthorized)
    post("/", AuthController, :login)
  end

  scope "/api/users/register", DostupWeb do
    pipe_through(:api_unauthorized)
    put("/", UserController, :register)
  end

  scope "/api/users/total", DostupWeb do
    pipe_through(:api_unauthorized)
    get("/", UserController, :total)
  end

  scope "/api/users/restore_password", DostupWeb do
    pipe_through(:api_unauthorized)
    post("/", UserController, :restore_password)
  end

  scope "/api/districts", DostupWeb do
    pipe_through(:api_unauthorized)
    resources("/", DistrictController, only: [:index, :show])
  end

  scope "/api/cities", DostupWeb do
    pipe_through(:api_unauthorized)
    resources("/", CityController, only: [:index, :show])
  end

  scope "/api", DostupWeb do
    pipe_through(:api)

    get("/users/me", UserController, :me)
    resources("/users", UserController, only: [:index, :show])

    get("/objects/by_user_district", ObjectController, :get_by_user_district)
    get("/objects/my", ObjectController, :my)
    patch("/objects/check/:id", ObjectController, :check)
    patch("/objects/uncheck/:id", ObjectController, :uncheck)
    resources("/objects", ObjectController, only: [:index, :update, :show])
    patch("/objects/:id/assign", ObjectController, :assign)
    patch("/objects/:id/unassign", ObjectController, :unassign)
    patch("/objects/unassign", ObjectController, :unassign)
    patch("/objects/status", ObjectController, :status)

    resources("/types", TypeController, only: [:index, :show])
  end
end
