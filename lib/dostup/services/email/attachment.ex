defmodule Dostup.Services.Email.Attachment do
  alias Dostup.Schemas.User
  alias Dostup.Services.Pdf.PdfFilePath

  @spec rules() :: Attachment.t()
  def rules() do
    Bamboo.Attachment.new(PdfFilePath.rules(), filename: "rules.pdf", content_type: "appliaction/pdf")
  end
end
