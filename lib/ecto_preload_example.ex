defmodule EctoPreloadExample do
  import Ecto.Query
  alias EctoPreloadExample.{Repo, Post, Author, Comment, Tag, Tagging}

  def list_posts(params \\ %{}) do
    build_query(params)
    |> Repo.all()
  end

  defp base_query() do
    from(posts in Post)
  end

  defp build_query(params) do
    query = base_query()

    query
    |> maybe_preload_author(params[:author])
  end

  defp maybe_preload_author(query, nil), do: query
  defp maybe_preload_author(query, _) do
    from(posts in query,
      left_join: author in Author,
      as: :preloaded_post_author,
      on: author.id == posts.author_id,
      preload: [author: author]
    )
  end
end
