defmodule StremioArchiveOrgAddon.Constants do
  @moduledoc """
  Shared constants used across the application
  """

  def addon_content_id_prefix, do: "archive-org.addon:"

  def search_url, do: "https://archive.org/advancedsearch.php"

  def image_url, do: "https://archive.org/services/img"

  def stream_url, do: "https://archive.org/services/stream"

  def meta_url, do: "https://archive.org/metadata"
end
