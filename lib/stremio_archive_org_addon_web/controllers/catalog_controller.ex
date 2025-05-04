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

        conn
        |> put_resp_header("content-type", "application/json")
        |> json(%{metas: []})
    end
  end

  defp response({:ok, data}, conn) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> put_resp_header("cache-control", "max-age=3600")
    |> json(%{metas: data})
  end

  defp response({:error, _error}, conn) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> json(%{metas: []})
  end
end
