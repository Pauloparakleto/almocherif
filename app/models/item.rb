class Item < ApplicationRecord
  validates :name, uniqueness: {message: "Este nome já está em uso!"}
  paginates_per 10
end
