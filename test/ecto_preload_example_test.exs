defmodule EctoPreloadExampleTest do
  use ExUnit.Case
  alias EctoPreloadExample.{Repo, Post, Author, Comment, Tag, Tagging}

  setup do
    Repo.delete_all(Post)
    Repo.delete_all(Author)
    Repo.delete_all(Tag)
    Repo.delete_all(Tagging)
    Repo.delete_all(Comment)

    author1 = %Author{name: "Author 1"} |> Repo.insert!()
    author2 = %Author{name: "Author 2"} |> Repo.insert!()
    post1 = %Post{title: "Post 1", body: "Post body 1", author_id: author1.id } |> Repo.insert!()
    post2 = %Post{title: "Post 2", body: "Post body 2", author_id: author2.id } |> Repo.insert!()

    tag1 = %Tag{name: "tag1"} |> Repo.insert!()
    tag2 = %Tag{name: "tag2"} |> Repo.insert!()

    %Tagging{tag_id: tag1.id, post_id: post1.id} |> Repo.insert!()
    %Tagging{tag_id: tag2.id, post_id: post1.id} |> Repo.insert!()

    %Tagging{tag_id: tag2.id, post_id: post2.id} |> Repo.insert!()

    comment = %Comment{post_id: post1.id, body: "Post 1", author_id: author2.id} |> Repo.insert!()

    {:ok, %{author1: author1, author2: author2, post1: post1, post2: post2, tag1: tag1, tag2: tag2, comment: comment}}
  end


  test "lists all posts by default" do
    posts = EctoPreloadExample.list_posts()

    assert length(posts) == 2
  end
end
