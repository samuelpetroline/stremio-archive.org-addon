defmodule StremioArchiveOrgAddon.TorrentParser do
  @moduledoc """
  Module for handling torrent file parsing and related functionality.
  Supports multiple video formats and provides robust error handling.
  """

  require Logger
  require StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.Decorators.LoggerDecorator

  # Common video file extensions
  @video_extensions [".mp4", ".mkv", ".avi", ".mov", ".wmv", ".flv", ".webm"]

  @doc """
  Parses a torrent file from a URL and returns the index of the first video file.

  ## Returns
    - `{:ok, file_index}` if a video file is found
    - `{:error, reason}` if no video file is found or an error occurs
  """
  @spec parse_torrent(String.t()) :: {:ok, non_neg_integer()} | {:error, String.t()}
  def parse_torrent(url) do
    LoggerDecorator.log(do_parse(url))
  end

  defp do_parse(url) do
    Logger.debug("Parsing torrent from URL: #{url}")

    with {:ok, body} <- download_torrent(url),
         {:ok, torrent_info} <- decode_torrent(body),
         {:ok, index} <- find_video_file_index(torrent_info) do
      {:ok, index}
    else
      {:error, reason} = error ->
        Logger.warning("Failed to parse torrent: #{inspect(reason)}")
        error
    end
  end

  defp download_torrent(url) do
    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status_code: status}} ->
        {:error, "HTTP request failed with status #{status}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{inspect(reason)}"}
    end
  end

  defp decode_torrent(body) do
    case Bento.decode(body) do
      {:ok, %{"info" => _} = info} -> {:ok, info}
      {:ok, _} -> {:error, "Invalid torrent structure: missing info dictionary"}
      error -> error
    end
  end

  defp find_video_file_index(%{"info" => info}) do
    cond do
      # Single file torrent
      Map.has_key?(info, "name") and Map.has_key?(info, "length") ->
        handle_single_file(info, has_video_extension?(info["name"]))

      # Multi-file torrent
      Map.has_key?(info, "files") ->
        handle_multiple_files(info)

      true ->
        {:error, "Invalid torrent structure: missing file information"}
    end
  end

  defp handle_single_file(%{"name" => _name}, true), do: {:ok, 0}

  defp handle_single_file(%{"name" => _name}, false),
    do: {:error, "Single file torrent does not contain a video file"}

  defp handle_multiple_files(%{"files" => files}) do
    index =
      files
      |> Enum.with_index()
      |> Enum.find(fn {file, _idx} ->
        path = file["path"] |> List.last()
        has_video_extension?(path)
      end)
      |> case do
        {_, idx} -> {:ok, idx}
        nil -> {:error, "No video file found in torrent"}
      end

    case index do
      {:ok, idx} -> {:ok, idx}
      error -> error
    end
  end

  defp has_video_extension?(filename) when is_binary(filename) do
    Enum.any?(@video_extensions, &String.ends_with?(String.downcase(filename), &1))
  end

  defp has_video_extension?(_), do: false
end
