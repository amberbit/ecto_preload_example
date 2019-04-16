defmodule EctoPreloadExample.Tag do
  use Ecto.Schema

  schema "tags" do
    field :name, :string

    has_many :taggings, EctoPreloadExample.Tagging
    has_many :posts, through: [:taggings, :post]
  end
end
