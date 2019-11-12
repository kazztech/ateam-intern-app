class AddBadgeColorToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :badge_color, :string
  end
end
