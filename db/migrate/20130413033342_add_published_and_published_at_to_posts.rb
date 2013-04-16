class AddPublishedAndPublishedAtToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :published, :boolean
    add_column :posts, :published_at, :timestamp
    add_index :posts, :published_at, name: "published_at_ix"
  end
end
