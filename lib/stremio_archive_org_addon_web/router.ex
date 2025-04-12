defmodule StremioArchiveOrgAddonWeb.Router do
  use StremioArchiveOrgAddonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StremioArchiveOrgAddonWeb.Controllers do
    pipe_through :api

    get "/manifest.json", ManifestController, :get
    get "/catalog/:type/:id", CatalogController, :search
    get "/catalog/:type/:id/:params", CatalogController, :search
    get "/meta/:type/:id", MetaController, :get
    get "/stream/:type/:id", StreamsController, :get
  end
end
