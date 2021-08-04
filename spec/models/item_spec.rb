require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'should create' do
    item = FactoryBot.create(:item)
    expect(item).to be_truthy
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

  xit 'should not update quantity' do
    item = FactoryBot.create(:item, quantity: 30)

    item.update(quantity: 15)

    expect(item.valid?).to eq(false)
    expect(item.errors.messages[:quantity].first).to eq("Você não pode atualizar quantidade a não ser mediante entrada e saída de itens!")
  end
end
