defmodule Dostup.Services.Serializer.GroupFieldEncoder do
  defstruct data: nil,
            groups: [],
            exclude: [:__meta__, :__struct__]

  def wrap(data, groups \\ [], exclude \\ [])

  def wrap(%Scrivener.Page{entries: entries} = data, groups, exclude) do
    %Scrivener.Page{
      data
      | entries: %__MODULE__{
          data: entries,
          groups: groups,
          exclude: exclude
        }
    }
  end

  def wrap(data, groups, exclude) do
    %__MODULE__{
      data: data,
      groups: groups,
      exclude: exclude
    }
  end
end

defimpl Jason.Encoder, for: Dostup.Services.Serializer.GroupFieldEncoder do
  alias Dostup.Services.Serializer.GroupFieldEncoder

  @spec encode(Dostup.Services.Serializer.GroupFieldEncoder.t(), any) :: iodata
  def encode(%GroupFieldEncoder{data: %_{} = item, groups: groups, exclude: exclude}, opts) do
    encode_one(item, groups, exclude, opts)
    |> Jason.Encode.map(opts)
  end

  def encode(%GroupFieldEncoder{data: items, groups: groups, exclude: exclude}, opts)
      when is_list(items) do
    Enum.map(items, &encode_one(&1, groups, exclude, opts))
    |> Jason.Encode.list(opts)
  end

  def encode(%GroupFieldEncoder{data: item, groups: groups, exclude: exclude}, opts)
      when is_map(item) do
    encode_item(item, exclude, groups, opts)
    |> Jason.Encode.map(opts)
  end

  defp encode_one(%module{} = item, groups, exclude, opts) do
    if function_exported?(module, :get_fields_for_group, 1) do
      Map.from_struct(item)
      |> Map.take(module.get_fields_for_group(groups |> MapSet.new()))
    else
      item
    end
    |> encode_item(exclude, groups, opts)
  end

  defp encode_one(items, groups, exclude, opts) when is_list(items) do
    Enum.map(items, &encode_one(&1, groups, exclude, opts))
    |> Jason.Encode.list(opts)
  end

  defp encode_one(item, groups, exclude, opts) when is_map(item) do
    item
    |> encode_item(exclude, groups, opts)
  end

  defp encode_item(%_{} = item, _exclude, _groups, _opts), do: item

  defp encode_item(item, exclude, groups, opts) do
    item
    |> Enum.filter(fn {k, _v} -> not (k in exclude) end)
    |> Enum.map(fn
      {k, %_{} = v} -> {k, encode_one(v, groups, exclude, opts)}
      {k, v} when is_list(v) -> {k, Enum.map(v, &encode_one(&1, groups, exclude, opts))}
      {k, v} -> {k, v}
    end)
    |> Enum.into(%{})
  end
end
