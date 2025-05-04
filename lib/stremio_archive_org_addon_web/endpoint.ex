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

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # Add CORS plug to allow all origins with specific headers for Stremio
  plug Corsica,
    origins: "*",
    allow_headers: ["accept", "content-type", "origin"],
    allow_methods: ["GET", "HEAD", "OPTIONS"],
    expose_headers: ["content-type"],
    max_age: 86400

  # Remove the default content type plug since we'll handle content types
  # in the specific controller actions

  plug StremioArchiveOrgAddonWeb.Router
end
