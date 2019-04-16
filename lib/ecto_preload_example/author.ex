defmodule EctoPreloadExample.Author do
  use Ecto.Schema

  schema "authors" do
    field(:name, :string)

    has_many(:posts, EctoPreloadExample.Post)
    has_many(:comments, EctoPreloadExample.Comment)
  end
end
