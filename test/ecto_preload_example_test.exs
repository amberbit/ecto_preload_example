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

  test "should not preload anything by default" do
    [post1, _] = EctoPreloadExample.list_posts()

    assert post1.author.__struct__ == Ecto.Association.NotLoaded
  end

  test "should preload authors if we need them in one query", %{author1: author1} do
    [post1, _] = EctoPreloadExample.list_posts(%{:author => true})

    assert post1.author.id == author1.id
  end

  test "should preload comments if we want to", %{comment: comment} do
    [post1, _] = EctoPreloadExample.list_posts(%{:comments => true})

    [comment] = post1.comments
    assert comment.id == comment.id
    assert comment.author.__struct__ == Ecto.Association.NotLoaded
  end

  test "should preload comments with authors if we want to", %{comment: comment, author2: author2} do
    [post1, _] = EctoPreloadExample.list_posts(%{:comments => %{:author => true}})

    [comment] = post1.comments
    assert comment.id == comment.id
    assert comment.author.id == author2.id
  end

  test "should preload tags if we want to" do
    [post1, post2] = EctoPreloadExample.list_posts(%{:tags => true})

    assert length(post1.tags) == 2
    assert length(post2.tags) == 1
  end

  test "should filter by tag name" do
    [post1, post2] = EctoPreloadExample.list_posts(%{:tags => true}, %{:tag => "tag2"})
    assert length(post1.tags) == 2
    assert length(post2.tags) == 1

    [post1, post2] = EctoPreloadExample.list_posts(%{}, %{:tag => "tag2"})
    assert post1.tags.__struct__ == Ecto.Association.NotLoaded
    assert post2.tags.__struct__ == Ecto.Association.NotLoaded

    [_post2] = EctoPreloadExample.list_posts(%{:tags => true}, %{:tag => "tag1"})
    [_post2] = EctoPreloadExample.list_posts(%{}, %{:tag => "tag1"})
  end
end
