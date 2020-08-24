defmodule Dostup.Services.Pdf.Generator do

  @spec create_cert!(String.t()) :: String.t()
  def create_cert!(fio) do
    make_html(fio)
    |> PdfGenerator.generate!(get_options())
  end

  @spec create_cert_bianry!(String.t()) :: binary()
  def create_cert_bianry!(fio) do
    make_html(fio)
    |> PdfGenerator.generate_binary!(get_options())
  end

  @spec make_html(String.t()) :: String.t()
  defp make_html(fio) do
    path = "#{:code.priv_dir(:dostup)}/templates/cert"
    file = "#{path}/index.html.eex"
    EEx.eval_file(file, fio: fio, path: path)
  end

  defp get_options() do
    [
      page_width: "11.695",
      page_height: "8.26772",
      delete_temporary: true,
      generator: :chrome,
      use_chrome: true,                           # <-- make sure you installed node/puppeteer
      prefer_system_executable: true,
      no_sandbox: true
    ]
  end

end
