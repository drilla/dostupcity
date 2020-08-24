defmodule Dostup.Services.Pdf.PdfFilePath do

  @app_name :dostup

  @spec rules :: String.t()
  def rules() do
    priv_dir() <> "/static/pdf/rules.pdf"
  end

  defp priv_dir(), do: :code.priv_dir(@app_name) |> to_string()

end
