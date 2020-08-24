defmodule Dostup.Services.Email.Sender do
  alias Dostup.Services.Email.Mailer

  require Logger

  @spec send_now(Bamboo.Email.t()) :: {:error, String.t()} | Bamboo.Email.t() | {any, Bamboo.Email.t()}
  def send_now(%Bamboo.Email{} = email) do
    try do
      Mailer.deliver_now(email)
    rescue
      e ->
        Logger.error(inspect(e))
        {:error, "Email was not sent. Your address is incorrect or service not available"}
    catch
      e  ->
        Logger.error(inspect(e))
        {:error, "Email was not sent. Your address is incorrect or service not available"}
    end
  end

end
