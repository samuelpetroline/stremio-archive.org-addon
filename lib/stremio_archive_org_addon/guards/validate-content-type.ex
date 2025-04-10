defmodule StremioArchiveOrgAddon.Guards.ValidateContentType do
  use Plug.Builder

  def init(params), do: params

  def call(%Plug.Conn{params: %{"type" => type}} = conn, opts) when type === opts do
    conn
  end

  def call(conn, _) do
    conn
    |> send_resp(400, Jason.encode!(%{"error" => "invalid content type"}))
    |> halt()
  end
end
