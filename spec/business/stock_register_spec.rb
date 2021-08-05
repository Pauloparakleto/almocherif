require 'rails_helper'

RSpec.describe StockRegister do
  context "when audited" do
    before do
      BusinessTime::Config.end_of_workday = "23:59 pm"
      BusinessTime::Config.beginning_of_workday = "00:00 am"
    end
    it 'should be deleted' do
      item = FactoryBot.create(:item, quantity: 0)
      item.delete
      expect(Item.count).to eq(0)
    end

    it 'should be audited false' do
      item = FactoryBot.create(:item, quantity: 0)

      expect(item.audited?).to eq(false)
    end

    it 'should be audited true' do
      item = FactoryBot.create(:item, quantity: 0)
      StockRegister.new(item: item, options: 2).entry
      expect(item.audited?).to eq(true)
    end

    it 'should not be deleted' do
      item = FactoryBot.create(:item, quantity: 0)
      StockRegister.new(item: item, options: 2).entry
      item.destroy
      expect(item.errors.any?).to eq(true)
    end

    it 'should no be deleted on exit' do
      item = FactoryBot.create(:item, quantity: 2)
      StockRegister.new(item: item, options: 2).exit
      item.destroy
      expect(item.errors.any?).to eq(true)
    end
  end
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
    before do
      BusinessTime::Config.beginning_of_workday = '6:00 am'
      BusinessTime::Config.end_of_workday = '15:00 pm'
      @time_now = Time.new(2021, 8, 5, 10)
      allow(Time).to receive(:now).and_return(@time_now)
    end

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
        BusinessTime::Config.beginning_of_workday = '9:00 am'
        BusinessTime::Config.end_of_workday = '18:00 pm'
        @time_now = Time.new(2021, 8, 5, 5)
        allow(Time).to receive(:now).and_return(@time_now)
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
