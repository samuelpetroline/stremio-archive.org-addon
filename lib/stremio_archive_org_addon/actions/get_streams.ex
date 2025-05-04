defmodule StremioArchiveOrgAddon.Actions.GetStreams do
  require Logger
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

  defp do_run(%{id: id} = _params) do
    id
    |> request()
    |> transform_data(id)
  end

  defp request(id) do
    Http.get(Constants.meta_url() <> "/" <> id <> "/files")
  end

  defp transform_data({:ok, %{"files" => files}}, id) do
    streams = extract_streams(files, id)
    subtitles = extract_subtitles(files, id)

    {:ok, %{streams: streams, subtitles: subtitles}}
  end

  defp transform_data({:ok, %{"result" => result}}, id) do
    streams = extract_streams(result, id)
    subtitles = extract_subtitles(result, id)

    {:ok, %{streams: streams, subtitles: subtitles}}
  end

  defp transform_data(_, _) do
    {:error, "Unable to get streams"}
  end

  defp extract_streams(items, id) do
    items
    |> Enum.filter(&is_stream_file?/1)
    |> Enum.map(&transform_to_stream_item(id, &1))
    |> Enum.filter(& &1)
    |> Task.async_stream(&transform_to_stream_response/1)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  defp extract_subtitles(items, id) do
    items
    |> Enum.filter(&is_subtitle_file?/1)
    |> Enum.map(&transform_to_stream_item(id, &1))
    |> Enum.filter(& &1)
  end

  defp is_stream_file?(%{"name" => name}) do
    String.match?(name, ~r/.*(.mp4|.torrent)$/)
  end

  defp is_subtitle_file?(%{"name" => name}) do
    String.match?(name, ~r/.*(.srt)$/)
  end

  defp transform_to_stream_item(id, %{"name" => name, "btih" => btih}) do
    %{
      id: id,
      name: name,
      url: build_stream_url(id, name),
      btih: btih
    }
  end

  defp transform_to_stream_item(id, %{"name" => name}) do
    %{
      id: id,
      name: name,
      url: build_stream_url(id, name),
      btih: nil
    }
  end

  defp transform_to_stream_item(_, _), do: nil

  defp build_stream_url(id, name) do
    Constants.download_url() <> "/" <> id <> "/" <> name
  end

  defp transform_to_stream_response(%{name: name, url: url, btih: btih} = _item) do
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
