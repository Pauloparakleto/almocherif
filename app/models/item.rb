class Item < ApplicationRecord
  validates :name, uniqueness: true
end
