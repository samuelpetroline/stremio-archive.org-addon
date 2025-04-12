defmodule StremioArchiveOrgAddon.Actions.GetMeta do
  require StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.Decorators.LoggerDecorator
  alias StremioArchiveOrgAddon.{Constants, Http}

  defstruct id: nil

  @type t :: %__MODULE__{
          id: String.t()
        }

  @type meta_item :: %{
          id: String.t(),
          type: String.t(),
          name: String.t(),
          description: String.t(),
          language: String.t(),
          genres: list(String.t()) | nil,
          director: list(String.t()) | nil
        }

  @spec run(t()) :: {:ok, meta_item()} | {:error, String.t()}
  def run(params) do
    LoggerDecorator.log(do_run(params))
  end

  defp do_run(params) do
    params
    |> request()
    |> transform_data()
  end

  defp request(%{id: id}) do
    Http.get(Constants.meta_url() <> "/" <> id)
  end

  defp transform_data(%{"response" => %{"docs" => items}}) do
    Enum.map(items, &transform_meta/1)
  end

  defp transform_meta(doc) do
    %{
      id: doc["identifier"],
      type: "movie",
      name: doc["title"],
      description: doc["description"],
      language: doc["language"],
      genres: split_string(doc["genre"]),
      director: split_string(doc["director"])
    }
  end

  defp split_string(string) when is_binary(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
  end

  defp split_string(nil), do: nil
end
