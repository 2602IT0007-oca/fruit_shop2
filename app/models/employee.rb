class Employee < ApplicationRecord
  has_many :customers # 追加
end