defmodule EctoPreloadExample.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :name, :string
    end

    create table(:tags) do
      add :name, :string
    end

    create table(:posts) do
      add :title, :string
      add :body, :text
      add :author_id, references(:authors, on_delete: :delete_all)
    end

    create table(:taggings) do
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :post_id, references(:posts, on_delete: :delete_all)
    end

    create table(:comments) do
      add :body, :text
      add :post_id, references(:posts, on_delete: :delete_all)
      add :author_id, references(:authors, on_delete: :delete_all)
    end
  end
end
