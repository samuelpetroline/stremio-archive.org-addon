defmodule StremioArchiveOrgAddon.Actions.GetStreams do
  require StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.{Constants, Http, TorrentParser}

  @type params :: %{
          id: String.t()
        }

  @type stream_item :: %{
          id: String.t(),
          name: String.t(),
          url: String.t(),
          btih: String.t() | nil
        }

  @type stream_response :: %{
          title: String.t(),
          url: String.t() | nil,
          infoHash: String.t() | nil,
          fileIdx: non_neg_integer() | nil
        }

  @spec run(params()) ::
          {:ok, %{streams: list(stream_response()), subtitles: list(stream_item())}}
          | {:error, String.t()}
  def run(params) do
    LoggerDecorator.log(do_run(params))
  end

  defp do_run(params) do
    params
    |> request()
    |> transform_data()
  end

  defp request(%{id: id}) do
    Http.get(Constants.meta_url() <> "/" <> id <> "/files")
  end

  defp transform_data(%{"response" => %{"docs" => items}}) do
    streams = extract_streams(items)
    subtitles = extract_subtitles(items)

    {:ok, %{streams: streams, subtitles: subtitles}}
  end

  defp extract_streams(items) do
    items
    |> Enum.filter(&is_stream_file?/1)
    |> Enum.map(&transform_to_stream_item/1)
    |> Task.async_stream(&transform_to_stream_response/1)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  defp extract_subtitles(items) do
    items
    |> Enum.filter(&is_subtitle_file?/1)
    |> Enum.map(&transform_to_stream_item/1)
  end

  defp is_stream_file?(%{"name" => name}) do
    String.match?(name, ~r/.*(.mp4|.torrent)$/)
  end

  defp is_subtitle_file?(%{"name" => name}) do
    String.match?(name, ~r/.*(.srt)$/)
  end

  defp transform_to_stream_item(%{"identifier" => id, "name" => name, "btih" => btih}) do
    %{
      id: id,
      name: name,
      url: build_stream_url(id, name),
      btih: btih
    }
  end

  defp transform_to_stream_item(%{"identifier" => id, "name" => name}) do
    %{
      id: id,
      name: name,
      url: build_stream_url(id, name),
      btih: nil
    }
  end

  defp build_stream_url(id, name) do
    Constants.stream_url() <> "/" <> id <> "/" <> name
  end

  defp transform_to_stream_response(%{name: name, url: url, btih: btih} = item) do
    if is_torrent?(name) do
      case TorrentParser.parse_torrent(url) do
        {:ok, file_idx} ->
          %{
            title: name,
            infoHash: btih,
            fileIdx: file_idx
          }
        {:error, _} ->
          %{
            title: name,
            url: url
          }
      end
    else
      %{
        title: name,
        url: url
      }
    end
  end

  defp is_torrent?(name), do: String.ends_with?(name, ".torrent")
end
