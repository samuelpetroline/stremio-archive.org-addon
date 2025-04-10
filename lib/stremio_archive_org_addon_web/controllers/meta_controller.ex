defmodule StremioArchiveOrgAddonWeb.Controllers.MetaController do
  require StremioArchiveOrgAddon.Decorators.Logger
  alias StremioArchiveOrgAddon.Decorators.Logger
  use StremioArchiveOrgAddonWeb, :controller

  plug StremioArchiveOrgAddon.Guards.ValidateId

  def index(conn, params) do
    Logger.log(do_index(conn, params))
  end

  defp do_index(conn, params) do
    json(conn, params)
  end
end
