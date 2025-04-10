defmodule StremioArchiveOrgAddon.Actions.SearchCatalog do
  require StremioArchiveOrgAddon.Decorators.Logger
  alias StremioArchiveOrgAddon.Decorators.Logger
  alias StremioArchiveOrgAddon.{Constants, Http, QueryBuilder}

  defstruct search: nil, genre: nil, skip: nil

  @type t :: %__MODULE__{
          search: String.t() | nil,
          genre: String.t() | nil,
          skip: non_neg_integer() | nil
        }

  @spec run(t()) :: {:ok, list(map())} | {:error, String.t()}
  def run(params) do
    Logger.log(do_run(params))
  end

  defp do_run(params) do
    query =
      params
      |> build_params()
      |> QueryBuilder.build()

    {:ok, data} = do_request(query, params)
    transform_data(data)
  end

  defp build_params(params) do
    search = Map.get(params, :search, nil)
    genre = Map.get(params, :genre, nil)

    case is_nil(search) do
      true ->
        %{
          # collection: "feature_films",
          mediatype: "movies",
          subject: genre
        }

      false ->
        %{
          # collection: "feature_films",
          mediatype: "movies",
          search: "#{search}*",
          subject: genre
        }
    end
  end

  defp do_request(query, params) do
    Http.get(Constants.search_url(), params: build_query(query, params))
  end

  defp build_query(query, params) do
    skip = Map.get(params, :skip, 0)

    %{
      q: query,
      count: skip + 100,
      sort: ["num_reviews desc", "avg_rating desc"],
      fl: [
        "avg_rating",
        "creator",
        "date",
        "description",
        "genre",
        "identifier",
        "language",
        "subject",
        "title",
        "type"
      ],
      output: "json"
    }
  end

  defp transform_data(%{"response" => %{"docs" => items}}) do
    {:ok, Enum.map(items, &transform_catalog/1)}
  end

  defp transform_catalog(doc) do
    %{
      id: Constants.addon_content_id_prefix() <> doc["identifier"],
      type: "movie",
      name: doc["title"],
      description: doc["description"],
      poster: "#{Constants.image_url()}/#{doc["identifier"]}"
    }
  end
end
