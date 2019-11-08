class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :parent_post_id, :default => nil
      t.string  :name
      t.string  :content
      t.integer :hide_pass
      t.boolean :is_hide,        :default => false
      t.timestamps
    end
  end
end
