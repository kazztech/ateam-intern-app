class Post < ApplicationRecord
    is_impressionable counter_cache: true
    belongs_to :category
end
