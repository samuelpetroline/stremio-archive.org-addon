defmodule StremioArchiveOrgAddon.Plugs.ParamsParser do
  @moduledoc """
  A plug that automatically parses route parameters into a map.
  Handles conversion of string parameters into a structured map format.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    params = transform_params(conn.params)
    %{conn | params: params}
  end

  defp transform_params(params) do
    Map.merge(params, build_map(params["params"]))
    |> Map.new(fn {key, value} -> {String.to_atom(key), value} end)
  end

  # Converts from string to map
  #  "search=fdfd.json" -> %{"search" => "fdfd"}
  #  "genre=action.json" -> %{"genre" => "action"}
  #  "skip=10.json" -> %{"skip" => 10}
  defp build_map(params) when not is_nil(params) do
    String.replace(params, ".json", "")
    |> String.split("=")
    |> Enum.chunk_every(2)
    |> Map.new(fn [key, value] -> {key, value} end)
  end

  defp build_map(_), do: %{}
end
