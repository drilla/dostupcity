defmodule DostupWeb.Auth.Token do
  use Joken.Config

  @token_expiration Application.get_env(:dostup, :token_life_time_hours, 2) * 60 * 60

  def token_config() do
    default_claims(skip: [:aud, :iss,], default_exp: @token_expiration)
    |> add_user_claim()
  end

  defp add_user_claim(claims) do
    Map.put(claims, "user_id", user_claim())
  end

  defp user_claim() do
    %Joken.Claim{
      generate: nil,
      validate: fn(id, _, _) -> is_integer(id) end
    }
  end
end
