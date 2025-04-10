defmodule StremioArchiveOrgAddon.Guards.ValidateId do
  use Plug.Builder
  alias StremioArchiveOrgAddon.Constants

  def call(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    if String.starts_with?(id, Constants.addon_content_id_prefix()) and String.length(id) > 0 do
      conn
    else
      conn
      |> send_resp(400, Jason.encode!(%{"error" => "invalid id"}))
      |> halt()
    end
  end
end
