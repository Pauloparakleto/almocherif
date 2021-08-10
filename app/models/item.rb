class Item < ApplicationRecord
  validates :name, uniqueness: { message: "Este nome já está em uso!" }
  before_destroy :can_destroy
  paginates_per 10

  has_many :logs, dependent: :restrict_with_error

  def can_destroy
    return unless audited?

    errors.add(:base, :invalid, message: "Message here")
    raise ActiveRecord::RecordInvalid
  end
end
