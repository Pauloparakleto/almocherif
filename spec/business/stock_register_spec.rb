require 'rails_helper'

RSpec.describe StockRegister do
  context "when entry" do
    it '2' do
      item = FactoryBot.create(:item, quantity: 0)
      params = { item: item, options: 2 }
      result = StockRegister.new(params).entry

      expect(result.quantity).to eq(2)
    end

    it 'counting with negative quantity' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: -2 }
      result = StockRegister.new(params).entry

      expect(result).to be_nil
    end

    it 'with zero quantity' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: 0 }
      result = StockRegister.new(params).entry

      expect(result).to be_nil
    end
  end

  context "when exit" do
    it '2' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: 2 }
      result = StockRegister.new(params).exit

      expect(result.quantity).to eq(0)
    end

    it 'whose result would be negative' do
      item = FactoryBot.create(:item, quantity: 0)
      params = { item: item, options: 2 }
      result = StockRegister.new(params).exit

      expect(result).to be_nil
    end

    it 'counting with negative quantity' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: -2 }
      result = StockRegister.new(params).exit

      expect(result).to be_nil
    end

    it 'with zero quantity' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: 0 }
      result = StockRegister.new(params).exit

      expect(result).to be_nil
    end
  end
end
