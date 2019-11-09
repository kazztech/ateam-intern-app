class AddImagePathToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :image_path, :string
  end
end
