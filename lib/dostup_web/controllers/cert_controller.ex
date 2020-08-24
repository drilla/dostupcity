defmodule DostupWeb.CertController do
  use DostupWeb, :controller

  alias Dostup.Services.Pdf.Generator
  alias Dostup.Schemas.User

  @spec get(Plug.Conn.t(), any) :: Plug.Conn.t()
  def get(%{assigns: %{user: %User{fio: fio}}} = conn, _params) do
    file = Generator.create_cert_bianry!(fio)
    conn
    |> Phoenix.Controller.send_download({:binary, file}, [
      disposition: :attachment,
      content_type: "application/pdf",
      filename: "cert.pdf"])
  end
end
