defmodule Dostup.Services.Password do
  def hash(password) do
    :crypto.hash(:md5, password) |> Base.encode16(case: :lower)
  end

  def generate_human(length) do
    :crypto.strong_rand_bytes(length)
     |> Base.encode64()
     |> binary_part(0, length)
     |> replace_inapropriate()
  end

  def replace_inapropriate(text) do
    Regex.replace(~r/[iIloO01]/, text, &get_random_char/0)
  end
  def get_random_char() do
    "abcdefghjkmnpqrstuwvxyz"
    |> String.split("")
    |> Enum.random()
  end
end
