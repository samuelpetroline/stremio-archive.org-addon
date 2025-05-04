defmodule StremioArchiveOrgAddon.QueryBuilder do
  @moduledoc """
  Converts a map of arguments into a Lucene query string.
  """

  @doc """
  Builds a Lucene query string from a map of arguments.
  Each key-value pair is converted into a field:value clause.

  ## Examples

      iex> QueryBuilder.build(%{collection: "movies", search: "matrix"})
      "collection:movies AND search:matrix"

      iex> QueryBuilder.build(%{collection: "movies", subject: nil})
      "collection:movies"
  """
  @spec build(map()) :: String.t()
  def build(args) when is_map(args) do
    args
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Enum.map(fn {key, value} -> ~s(#{key}:"#{escape_value(value)}") end)
    |> Enum.join(" AND ")
  end

  defp escape_value(value) when is_binary(value) do
    # Escape special Lucene characters
    value
    |> String.replace(~r/([+\-&|!(){}\[\]^"~*?:\\])/, "\\\\\\1")
  end

  defp escape_value(value), do: to_string(value)
end
