class Item < ApplicationRecord
  validates :name, uniqueness: { message: "Este nome já está em uso!" }
  validates_with StockRegisterValidator
  before_destroy :can_destroy
  paginates_per 10

  has_many :logs

  def can_destroy
    if self.audited?
      errors.add(:base, :invalid, message: "Message here")
      raise ActiveRecord::RecordInvalid
    end
  end
end
