defmodule EctoPreloadExample.Tagging do
  use Ecto.Schema

  schema "taggings" do
    belongs_to :post, EctoPreloadExample.Post
    belongs_to :tag, EctoPreloadExample.Post
  end
end
