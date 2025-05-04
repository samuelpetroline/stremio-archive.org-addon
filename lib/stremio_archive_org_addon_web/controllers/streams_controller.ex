defmodule StremioArchiveOrgAddonWeb.Controllers.StreamsController do
  require Logger
  require StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.Decorators.LoggerDecorator
  use StremioArchiveOrgAddonWeb, :controller

  alias StremioArchiveOrgAddon.Actions.GetStreams

  plug StremioArchiveOrgAddon.Guards.ValidateContentType, "movie"
  plug StremioArchiveOrgAddon.Guards.ValidateId
  plug StremioArchiveOrgAddon.Plugs.ParamsParser

  def get(conn, params) do
    LoggerDecorator.log(do_get(conn, params))
  end

  defp do_get(conn, params) do
    try do
      GetStreams.run(params)
      |> response(conn)
    rescue
      e ->
        Logger.error("Error in streams get: #{inspect(e)}")
        json(conn, %{streams: []})
    end
  end

  defp response({:ok, data}, conn) do
    json(conn, data)
  end

  defp response({:error, _error}, conn) do
    json(conn, %{streams: []})
  end
end
