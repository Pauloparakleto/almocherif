class StockRegisterValidator < ActiveModel::Validator
  def validate(record)
    if record.quantity.negative?
      record.errors.add :base, "A quantidade retirada é superior ao estoque!"
    end
  end
end