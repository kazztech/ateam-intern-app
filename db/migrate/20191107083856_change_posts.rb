class ChangePosts < ActiveRecord::Migration[5.1]
  def change
    add_column    :posts, :title,     :string
    change_column :posts, :hide_pass, :string
    rename_column :posts, :hide_pass, :edit_pass
  end
end
