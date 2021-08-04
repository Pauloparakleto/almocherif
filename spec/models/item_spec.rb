require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'should create' do
    item = FactoryBot.create(:item)
    expect(item).to be_truthy
  end

  it 'should delete' do
    item = FactoryBot.create_list(:item, 10)
    item.second.delete
    expect(item.count).to eq(9)
  end

  it 'should create list' do
    item = FactoryBot.create_list(:item, 10)
    expect(item.count).to eq(10)
  end

  it 'update quantity' do
    item = FactoryBot.create(:item)

    quantity = item.quantity
    item.update(quantity: 20)

    expect(item.quantity).to eq(20)
    expect(quantity).not_to eq(item.quantity)
  end
end
