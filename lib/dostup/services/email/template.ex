defmodule Dostup.Services.Email.Template do
  alias Dostup.Schemas.User

  @spec registration(User.t(), String.t()) :: String.t()
  def registration(%User{
        fio: fio,
        login: login,
      }, password) do
    do_render_template("register",
      fio: fio,
      login: login,
      password: password
    )
  end

  @spec reset_password(User.t(), String.t()) :: String.t()
  def reset_password(%User{
        fio: fio,
        login: login
      }, password) do
    do_render_template("reset_password",
      fio: fio,
      login: login,
      password: password
    )
  end

  defp do_render_template(name, assigns) do
    file = "#{:code.priv_dir(:dostup)}/templates/email/#{name}.html.eex"

    EEx.eval_file(file, assigns) |> to_string()
  end
end
