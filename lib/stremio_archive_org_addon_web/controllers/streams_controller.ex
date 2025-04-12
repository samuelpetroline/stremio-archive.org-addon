defmodule StremioArchiveOrgAddonWeb.Controllers.StreamsController do
  require Logger
  require StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.Decorators.LoggerDecorator
  use StremioArchiveOrgAddonWeb, :controller

  alias StremioArchiveOrgAddon.Actions.GetStreams

  plug StremioArchiveOrgAddon.Guards.ValidateId
  plug StremioArchiveOrgAddon.Plugs.ParamsParser
  plug StremioArchiveOrgAddon.Guards.ValidateContentType, "movie"

  def get(conn, params) do
    LoggerDecorator.log(do_get(conn, params))
  end

  defp do_get(conn, params) do
    try do
      GetStreams.run(params)
      |> response(conn)
    rescue
      e ->
        Logger.error("Error in catalog search: #{inspect(e)}")
        json(conn, [])
    end
  end

  defp response({:ok, data}, conn) do
    json(conn, data)
  end
end
