defmodule StremioArchiveOrgAddon.Http do
  require Logger
  require StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.Decorators.LoggerDecorator

  def get(url, options \\ [], headers \\ []) do
    LoggerDecorator.log(do_get(url, options, headers))
  end

  defp do_get(url, options, headers) do
    query_params = Keyword.get(options, :params, %{})
    url_with_params = build_url_with_params(url, query_params)

    Logger.info("url_with_params: #{inspect(url_with_params)}")

    url_with_params
    |> HTTPoison.get(headers, Keyword.delete(options, :params))
    |> handle_response()
  end

  defp build_url_with_params(url, params) when map_size(params) == 0, do: url

  defp build_url_with_params(url, params) do
    query_string =
      params
      |> Enum.map(fn {key, value} -> serialize_param(to_string(key), value) end)
      |> Enum.join("&")

    "#{url}?#{query_string}"
  end

  defp serialize_param(key, value) when is_list(value) do
    value
    |> Enum.map(fn v -> "#{key}%5B%5D=#{URI.encode_www_form(to_string(v))}" end)
    |> Enum.join("&")
  end

  defp serialize_param(key, value) do
    "#{key}=#{URI.encode_www_form(to_string(value))}"
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}),
    do: {:ok, Jason.decode!(body)}

  defp handle_response({:ok, %HTTPoison.Response{status_code: status, body: body}}),
    do: {:error, "HTTP #{status}: #{body}"}

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}
end
