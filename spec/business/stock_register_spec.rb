require 'rails_helper'

RSpec.describe StockRegister do
  context 'when entry' do
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

  context 'when exit' do
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

  describe 'out of business time' do
    context 'when exit' do
      before do
        BusinessTime::Config.beginning_of_workday = '17:59 pm'
        BusinessTime::Config.end_of_workday = '18:00 pm'
      end

      it '2' do
        item = FactoryBot.create(:item, quantity: 2)
        params = { item: item, options: 2 }
        result = StockRegister.new(params).exit

        expect(result).to be_nil
      end
    end

    context 'when exit on weekend' do
      before do
        BusinessTime::Config.beginning_of_workday = '9:00 am'
        BusinessTime::Config.end_of_workday = '18:00 pm'
        @time_now = Time.new(2021, 8, 1)
        allow(Time).to receive(:now).and_return(@time_now)
      end

      it '2' do
        item = FactoryBot.create(:item, quantity: 2)
        params = { item: item, options: 2 }
        result = StockRegister.new(params).exit

        expect(result).to be_nil
      end
    end
  end
end
