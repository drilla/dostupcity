defmodule DostupWeb.StaticPdfController do
  use DostupWeb, :controller

  # example! serve pdf directly
  # @spec rules(Plug.Conn.t(), any) :: Plug.Conn.t()
  # def rules(conn, _params) do
  #  priv_dir = :code.priv_dir(:dostup) |> to_string()
  #  file  = "#{priv_dir}/static/pdf/rules.pdf"
  #
  #    conn
  #    |> Phoenix.Controller.send_download({:file, file}, [
  #      disposition: :inline,
  #      content_type: "application/pdf",
  #      filename: "rules.pdf"])
  #  end
end
