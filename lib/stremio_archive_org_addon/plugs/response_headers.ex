defmodule StremioArchiveOrgAddon.Plugs.ResponseHeaders do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> put_resp_header("cache-control", "max-age=3600")
  end
end
