class Post < ApplicationRecord
    # バリデーション
    validates :name, length: { in: 1..20 }
    validates :edit_pass, length: { in: 1..12 }
    validates :title, length: { in: 4..32 }

    is_impressionable counter_cache: true
    
    belongs_to :category
end
