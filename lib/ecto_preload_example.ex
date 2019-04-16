defmodule EctoPreloadExample do
  import Ecto.Query
  alias EctoPreloadExample.{Repo, Post, Author, Comment, Tag, Tagging}

  def list_posts() do
    build_query()
    |> Repo.all()
  end

  defp base_query() do
    from(posts in Post)
  end

  defp build_query() do
    query = base_query()

    query
  end
end
