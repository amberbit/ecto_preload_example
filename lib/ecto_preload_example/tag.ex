defmodule EctoPreloadExample.Tag do
  use Ecto.Schema

  schema "tags" do
    field :name, :string

    belongs_to :post, EctoPreloadExample.Post

    has_many :taggings, EctoPreloadExample.Tagging
    has_many :posts, through: [:taggings, :post]
  end
end
