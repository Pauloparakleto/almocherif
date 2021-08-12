require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'should create' do
    item = FactoryBot.create(:item)
    expect(item).to be_truthy
  end
  it 'should has unique name' do
    product_name = Faker::Commerce.product_name
    FactoryBot.create(:item, name: product_name)
    item_second = FactoryBot.build(:item, name: product_name)

    expect(item_second).not_to be_valid
    expect(item_second.errors.messages[:name].first).to eq("Este nome já está em uso!")
  end
  it 'should delete' do
    item = FactoryBot.create_list(:item, 10)
    item.second.delete
    expect(Item.count).to eq(9)
  end

  it 'should create list' do
    item = FactoryBot.create_list(:item, 10)
    expect(item.count).to eq(10)
  end

  it 'update name' do
    item = FactoryBot.create(:item)

    name = item.name
    item.update(name: "Flash Driver")

    expect(item.name).to eq("Flash Driver")
    expect(name).not_to eq(item.name)
  end

  it 'should not update to negative quantity' do
    item = FactoryBot.create(:item, quantity: 30)

    item.update(quantity: -15)

    expect(item.valid?).to eq(false)
    expect(item.errors[:base]).to eq(["A quantidade retirada é superior ao estoque!"])
  end
end
