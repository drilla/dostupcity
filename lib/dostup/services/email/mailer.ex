defmodule Dostup.Services.Email.Mailer do
  use Bamboo.Mailer, otp_app: :dostup
  alias Dostup.Schemas.User
  import Bamboo.Email
  alias Dostup.Services.Pdf.PdfFilePath
  alias Dostup.Services.Email.Template
  alias Dostup.Services.Email.Attachment

  @from get_in(Application.get_env(:dostup, :emails), [:from])
  @config Application.get_env(:dostup, Dostup.Services.Email.Mailer, %{})

  import Ecto.Changeset, only: [validate_change: 3]

  @spec new_registration_email(User.t(), String.t()) :: Bamboo.Email.t()
  def new_registration_email(%User{email: email} = user, password) do
    new_email()
    |> from(@from)
    |> to(email)
    |> subject(get_register_subj())
    |> put_attachment(Attachment.rules())
    |> html_body(Template.registration(user, password))
    |> check_is_text()
  end

  @spec new_reset_password_email(User.t(), String.t()) :: Bamboo.Email.t()
  def new_reset_password_email(%User{email: email} = user, password) do
    new_email()
    |> from(@from)
    |> to(email)
    |> subject(get_restore_subj())
    |> html_body(Template.reset_password(user, password))
    |> check_is_text()
  end


  defp check_is_text(%{html_body: body} = mail) do
    text? = get_in(@config, [:text])

    if text? do
      Map.put(mail, :html_body, sanitize(body))
    else
      mail
    end
  end

  def sanitize(text) do
    {:safe, result} =
      text
      |> String.replace(~r/<li>/, "\\g{1}- ", global: true)
      |> String.replace(
        ~r/<\/?\s?br>|<\/\s?p>|<\/\s?li>|<\/\s?div>|<\/\s?h.>/,
        "\\g{1}\n\r",
        global: true
      )
      |> PhoenixHtmlSanitizer.Helpers.sanitize(:strip_tags)

    result
  end

  defp get_register_subj() do
    get_in(Application.get_env(:dostup, :emails), [:register_subj])
  end

  defp get_activation_subj() do
    get_in(Application.get_env(:dostup, :emails), [:activation_subj])
  end

  defp get_restore_subj() do
    get_in(Application.get_env(:dostup, :emails), [:new_password_subj])
  end

  @spec validate_email(Ecto.Changeset.t(), atom, any) :: Ecto.Changeset.t()
  defp validate_email(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, email ->
      case EmailChecker.valid?(email) do
        true -> []
        false -> [{field, options[:message] || "email incorrect"}]
      end
    end)
  end
end
