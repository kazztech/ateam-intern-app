class RenameFromImagePathToImageOnPosts < ActiveRecord::Migration[5.1]
  def change
    rename_column :posts, :image_path, :image
  end
end
