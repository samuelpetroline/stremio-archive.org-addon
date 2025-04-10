defmodule StremioArchiveOrgAddonWeb.Router do
  use StremioArchiveOrgAddonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StremioArchiveOrgAddonWeb.Controllers do
    pipe_through :api

    get "/manifest.json", ManifestController, :index
    get "/catalog/:type/:id", CatalogController, :search
    get "/catalog/:type/:id/:params", CatalogController, :search
    get "/meta/:type/:id", MetaController, :index
    get "/stream/:type/:id", StreamsController, :index
  end
end
