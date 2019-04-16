defmodule EctoPreloadExample do
  import Ecto.Query
  alias EctoPreloadExample.{Repo, Post, Author, Comment, Tag, Tagging}

  def list_posts(params \\ %{}, filters \\ %{}) do
    build_query(params, filters)
    |> Repo.all()
  end

  defp base_query() do
    from(posts in Post)
  end

  defp build_query(params, filters) do
    query = base_query()

    query
    |> maybe_preload_author(params[:author])
    |> maybe_preload_comments(params[:comments])
    |> maybe_preload_tags(params[:tags])
    |> maybe_filter_by_tag(filters[:tag])
  end

  defp maybe_preload_author(query, nil), do: query

  defp maybe_preload_author(query, _) do
    from(posts in query,
      left_join: author in Author,
      on: author.id == posts.author_id,
      preload: [author: author]
    )
  end

  defp maybe_preload_comments(query, nil), do: query
  defp maybe_preload_comments(query, true), do: maybe_preload_comments(query, %{})

  defp maybe_preload_comments(query, params) do
    comments_query =
      from(comment in Comment)
      |> maybe_preload_comment_author(params[:author])

    from(posts in query, preload: [comments: ^comments_query])
  end

  defp maybe_preload_comment_author(query, nil), do: query

  defp maybe_preload_comment_author(query, _) do
    from(comment in query,
      left_join: author in Author,
      on: author.id == comment.author_id,
      preload: [author: author]
    )
  end

  defp maybe_preload_tags(query, nil), do: query

  defp maybe_preload_tags(query, _) do
    tags_query =
      from(tagging in Tagging,
        inner_join: tag in Tag,
        on: tag.id == tagging.tag_id,
        preload: [tag: tag]
      )

    query = from(posts in query, preload: [{:taggings, ^tags_query}, :tags])
  end

  defp maybe_filter_by_tag(query, nil), do: query

  defp maybe_filter_by_tag(query, tag_name) do
    from(posts in query,
      inner_join: tagging in Tagging,
      on: tagging.post_id == posts.id,
      inner_join: tag in Tag,
      on: tag.id == tagging.tag_id,
      where: tag.name == ^tag_name
    )
  end
end
