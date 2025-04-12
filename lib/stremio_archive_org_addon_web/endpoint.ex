defmodule StremioArchiveOrgAddonWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :stremio_archive_org_addon

  # Serve at "/" the static files from "priv/static" directory.
  plug Plug.Static,
    at: "/",
    from: :stremio_archive_org_addon,
    gzip: false,
    only: StremioArchiveOrgAddonWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug :put_default_content_type

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # Add CORS plug to allow all origins
  plug Corsica,
    origins: "*",
    allow_headers: :all,
    allow_methods: :all

  plug StremioArchiveOrgAddonWeb.Router

  # Add function to set default content type
  defp put_default_content_type(conn, _) do
    Plug.Conn.put_resp_content_type(conn, "application/json")
  end
end
