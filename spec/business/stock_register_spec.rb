require 'rails_helper'

RSpec.describe StockRegister do
  it 'should entry' do
    item = FactoryBot.create(:item, quantity: 0)
    result = StockRegister.new(item: item, options: 2).entry

    expect(result.quantity).to eq(2)
  end

  it 'should exit' do
    item = FactoryBot.create(:item, quantity: 2)
    result = StockRegister.new(item: item, options: 2).exit

    expect(result.quantity).to eq(0)
  end
end
