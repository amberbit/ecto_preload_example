defmodule EctoPreloadExample.Comment do
  use Ecto.Schema

  schema "comments" do
    field :body, :string

    belongs_to :author, EctoPreloadeExample.Author
    belongs_to :post, EctoPreloadExample.Post
  end
end
