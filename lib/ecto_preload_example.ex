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
    |> maybe_preload_comments(params[:comments])
    |> maybe_preload_tags(params[:tags])
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
    from(posts in query,
      left_join: comment in Comment,
      as: :preloaded_comment,
      on: comment.post_id == posts.id,
      preload: [comments: comment]
    )
    |> maybe_preload_comment_author(params[:author])
  end

  defp maybe_preload_comment_author(query, nil), do: query
  defp maybe_preload_comment_author(query, _) do
    from([posts, preloaded_comment: comment] in query,
      left_join: author in Author,
      on: author.id == comment.author_id,
      preload: [comments: {comment, author: author}]
    )
  end

  defp maybe_preload_tags(query, nil), do: query
  defp maybe_preload_tags(query, _) do
    from(posts in query,
      left_join: tagging in Tagging,
      on: tagging.post_id == posts.id,
      left_join: tag in Tag,
      on: tag.id == tagging.tag_id,
      preload: [tags: tag]
    )
  end
end
