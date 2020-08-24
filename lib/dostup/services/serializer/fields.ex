defmodule Dostup.Services.Serializer.Fields do
  defmacro __using__(fields) do
    quote do
      @json_group_fields unquote(fields)

      def get_fields_for_group(%MapSet{} = group) do
        Enum.reduce(@json_group_fields, [], fn {f, g}, acc ->
          if has_group?(group, g), do: [f | acc], else: acc
        end)
      end

      def get_fields_for_group(group), do: get_fields_for_group(MapSet.new(group))

      def has_group?(%MapSet{} = group, %MapSet{} = g) do
        group
        |> MapSet.intersection(g)
        |> MapSet.size() > 0
      end

      def has_group?(group, g), do: has_group?(group, MapSet.new(g))
    end
  end
end
