defmodule DostupWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use DostupWeb, :controller
      use DostupWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: DostupWeb

      import Plug.Conn
      import DostupWeb.Gettext
      alias DostupWeb.Router.Helpers, as: Routes

    #  defp render_result({:error, e}, conn) do
    #    conn
    #    |> put_status(400)
    #    |> put_view(DostupWeb.ErrorView)
    #    |> assign(:error, e)
    #    |> render("error_with_details.json")
    #  end
#
     # defp render_result({:error, 401, _e}, conn) do
     #   conn
     #   |> put_status(401)
     #   |> Phoenix.Controller.put_view(DostupWeb.ErrorView)
     #   |> Phoenix.Controller.render("401.json")
     # end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/dostup_web/templates",
        namespace: DostupWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import DostupWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      #import DostupWeb.ErrorHelpers
      import DostupWeb.Gettext
      alias DostupWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
