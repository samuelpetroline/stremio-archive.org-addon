defmodule StremioArchiveOrgAddonWeb.Controllers.CatalogController do
  require Logger
  require StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.Decorators.LoggerDecorator

  use StremioArchiveOrgAddonWeb, :controller

  alias StremioArchiveOrgAddon.Actions.SearchCatalog

  plug StremioArchiveOrgAddon.Guards.ValidateContentType, "movie"
  plug StremioArchiveOrgAddon.Plugs.ParamsParser

  def search(conn, params) do
    LoggerDecorator.log(do_search(conn, params))
  end

  defp do_search(conn, params) do
    try do
      SearchCatalog.run(params)
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

  defp response({:error, _error}, conn) do
    json(conn, [])
  end
end
