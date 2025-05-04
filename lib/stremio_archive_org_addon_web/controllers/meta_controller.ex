defmodule StremioArchiveOrgAddonWeb.Controllers.MetaController do
  require Logger
  require StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.Decorators.LoggerDecorator

  use StremioArchiveOrgAddonWeb, :controller

  alias StremioArchiveOrgAddon.Actions.GetMeta

  plug StremioArchiveOrgAddon.Guards.ValidateContentType, "movie"
  plug StremioArchiveOrgAddon.Guards.ValidateId
  plug StremioArchiveOrgAddon.Plugs.ParamsParser

  def get(conn, params) do
    LoggerDecorator.log(do_get(conn, params))
  end

  defp do_get(conn, params) do
    try do
      GetMeta.run(params)
      |> response(conn)
    rescue
      e ->
        Logger.error("Error in meta get: #{inspect(e)}")

        conn
        |> json(%{meta: nil})
    end
  end

  defp response({:ok, data}, conn) do
    conn
    |> json(%{meta: data})
  end

  defp response({:error, _error}, conn) do
    conn
    |> json(%{meta: nil})
  end
end
