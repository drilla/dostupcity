defimpl Jason.Encoder, for: Ecto.Changeset do
  alias DostupWeb.ErrorHelpers

  @spec encode(Ecto.Changeset.t(), any) :: iodata
  def encode(%Ecto.Changeset{} = item, opts) do
    item.errors
    |> Enum.map(fn {k, e} ->
      {k, ErrorHelpers.translate_error(e)}
    end)
    |> Enum.into(%{})
    |> Jason.Encode.map(opts)
  end
end
