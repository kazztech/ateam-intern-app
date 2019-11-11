class Post < ApplicationRecord
    is_impressionable
    belongs_to :category
end
