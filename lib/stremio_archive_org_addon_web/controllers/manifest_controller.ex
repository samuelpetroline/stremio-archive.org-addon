defmodule StremioArchiveOrgAddonWeb.Controllers.ManifestController do
  require StremioArchiveOrgAddon.Decorators.Logger
  alias StremioArchiveOrgAddon.Decorators.Logger
  use StremioArchiveOrgAddonWeb, :controller

  alias StremioArchiveOrgAddon.Constants

  def index(conn, _params) do
    Logger.log(do_index(conn))
  end

  defp do_index(conn) do
    json(conn, %{
      id: "stremio.archive.org.addon",
      version: "2.0.0",
      name: "Archive.org Movies",
      description: "Public domain movies available on Archive.org",
      resources: [
        "catalog",
        %{
          name: "meta",
          types: ["movie"],
          idPrefixes: [Constants.addon_content_id_prefix()]
        },
        %{
          name: "stream",
          types: ["movie"]
        }
      ],
      types: ["movie"],
      catalogs: [
        %{
          type: "movie",
          id: Constants.addon_content_id_prefix(),
          name: "Archive.org movies",
          extra: [
            %{
              name: "search",
              isRequired: false
            },
            %{
              name: "genre",
              isRequired: false,
              options: [
                "Drama",
                "Comedy",
                "Crime",
                "Mystery",
                "Western",
                "Romance",
                "Thriller",
                "Horror",
                "Adventure",
                "Action",
                "Silent",
                "War",
                "Film Noir",
                "Sci-Fi",
                "Musical"
              ]
            },
            %{
              name: "skip",
              isRequired: false
            }
          ]
        }
      ]
    })
  end
end
