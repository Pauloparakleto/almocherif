class Item < ApplicationRecord
  validates :name, uniqueness: {message: "Este nome já está em uso!"}
end
