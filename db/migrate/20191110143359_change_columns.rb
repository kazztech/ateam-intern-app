class ChangeColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :category_id, :integer
    add_column :posts, :reply_count, :integer
    remove_column :posts, :image, :string
  end
end
