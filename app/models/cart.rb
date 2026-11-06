class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items
  validates :user_id, uniqueness: true # 追加
end
