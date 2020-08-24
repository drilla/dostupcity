defmodule DostupWeb.ErrorView do
  use DostupWeb, :view
  import DostupWeb.ErrorHelpers, only: [translate_error: 1]
  require Logger

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  def render("login_not_successful.json", _assigns) do
    %{errors: %{detail: translate_error("login - password pair is incorrect")}}
  end

  def render("error_with_details.json", %{error: reason}) when is_binary(reason) do
    %{errors: %{detail: translate_error(reason)}}
  end

  def render("error_with_details.json", %{error: reason}) do
    %{errors: %{detail: reason}}
  end


  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
