defmodule StremioArchiveOrgAddon.Actions.GetMeta do
  require Logger
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
    Http.get(
      (Constants.meta_url() <> "/" <> String.replace(id, Constants.addon_content_id_prefix(), ""))
      |> String.replace(".json", "")
    )
  end

  defp transform_data({:ok, %{"metadata" => metadata}}) do
    {:ok, transform_meta(metadata)}
  end

  defp transform_data(_) do
    {:error, "Unable to get meta"}
  end

  defp transform_meta(doc) do
    %{
      id: Constants.addon_content_id_prefix() <> doc["identifier"],
      type: "movie",
      name: doc["title"],
      description: doc["description"],
      language: doc["language"],
      genres: split_string(doc["subject"], ";"),
      director: split_string(doc["director"], ",")
    }
  end

  defp split_string(string, delimiter) when is_binary(string) do
    string
    |> String.split(delimiter)
    |> Enum.map(&String.trim/1)
  end

  defp split_string(_, _), do: nil
end
