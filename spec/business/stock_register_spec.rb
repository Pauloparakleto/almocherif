require 'rails_helper'

RSpec.describe StockRegister do
  it 'should entry' do
    item = FactoryBot.create(:item, quantity: 0)
    params = { item: item, options: 2 }
    result = StockRegister.new(params).entry

    expect(result.quantity).to eq(2)
  end

  it 'should exit' do
    item = FactoryBot.create(:item, quantity: 2)
    params = { item: item, options: 2 }
    result = StockRegister.new(params).exit

    expect(result.quantity).to eq(0)
  end
end
