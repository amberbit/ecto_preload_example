defmodule EctoPreloadExample.Post do
  use Ecto.Schema

  schema "posts" do
    field(:title, :string)
    field(:body, :string)

    belongs_to(:author, EctoPreloadeExample.Author)
    has_many(:taggings, EctoPreloadExample.Tagging)
    has_many(:comments, EctoPreloadExample.Comment)
    has_many(:tags, through: [:taggings, :tag])
  end
end
