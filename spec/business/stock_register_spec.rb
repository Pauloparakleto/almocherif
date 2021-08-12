require 'rails_helper'

RSpec.describe StockRegister do
  context "when log register" do
    before do
      email = Faker::Internet.unique.email
      email_second = Faker::Internet.unique.email
      @user = FactoryBot.create(:user, email: email)
      @user_second = FactoryBot.create(:user, email: email_second)
      BusinessTime::Config.beginning_of_workday = "00:00 am"
      BusinessTime::Config.end_of_workday = "23:59 pm"
    end

    it "has user entry" do
      item = FactoryBot.create(:item, quantity: 0)
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).entry
      result = StockRegister.new(item: item, options: { quantity: 2, user: @user_second }).entry

      expect(result.logs.first.user).to eq(@user)
      expect(result.logs.second.user).to eq(@user_second)

    end

    it "has user exits" do
      item = FactoryBot.create(:item, quantity: 10)
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).exit
      result = StockRegister.new(item: item, options: { quantity: 2, user: @user_second }).exit

      expect(result.logs.first.user).to eq(@user)
      expect(result.logs.second.user).to eq(@user_second)

    end

    it 'many entries' do
      item = FactoryBot.create(:item, quantity: 0)
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).entry
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).entry
      result = StockRegister.new(item: item, options: { quantity: 2, user: @user }).entry

      expect(result.logs.first.product_name).to eq(item.name)
      expect(result.logs.second.product_name).to eq(item.name)
      expect(result.logs.last.product_name).to eq(item.name)

      expect(result.logs.first.quantity).to eq(2)
      expect(result.logs.second.quantity).to eq(2)
      expect(result.logs.last.quantity).to eq(2)

      expect(result.logs.first.action).to eq("entrada")
      expect(result.logs.second.action).to eq("entrada")
      expect(result.logs.last.action).to eq("entrada")
    end

    it 'many exits' do
      item = FactoryBot.create(:item, quantity: 20)
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).exit
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).exit
      result = StockRegister.new(item: item, options: { quantity: 2, user: @user }).exit

      expect(result.logs.first.product_name).to eq(item.name)
      expect(result.logs.second.product_name).to eq(item.name)
      expect(result.logs.last.product_name).to eq(item.name)

      expect(result.logs.first.quantity).to eq(2)
      expect(result.logs.second.quantity).to eq(2)
      expect(result.logs.last.quantity).to eq(2)

      expect(result.logs.first.action).to eq("saída")
      expect(result.logs.second.action).to eq("saída")
      expect(result.logs.last.action).to eq("saída")
    end
  end

  context "when audited" do
    before do
      BusinessTime::Config.end_of_workday = "23:59 pm"
      BusinessTime::Config.beginning_of_workday = "00:00 am"
      @user = FactoryBot.create(:user)
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
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).entry
      expect(item.audited?).to eq(true)
    end

    it 'should not be deleted' do
      item = FactoryBot.create(:item, quantity: 0)
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).entry

      expect { item.destroy }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should no be deleted on exit' do
      item = FactoryBot.create(:item, quantity: 2)
      StockRegister.new(item: item, options: { quantity: 2, user: @user }).exit
      expect { item.destroy }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  context 'when entry' do
    before do
      @user = FactoryBot.create(:user)
    end
    it '2' do
      item = FactoryBot.create(:item, quantity: 0)
      params = { item: item, options: { quantity: 2, user: @user } }
      result = StockRegister.new(params).entry

      expect(result.quantity).to eq(2)
    end

    it 'counting with negative quantity' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: { quantity: -2, user: @user } }
      result = StockRegister.new(params).entry

      expect(result).to be_nil
    end

    it 'with zero quantity' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: { quantity: 0, user: @user } }
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
      @user = FactoryBot.create(:user)
    end

    it '2' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: { quantity: 2, user: @user } }
      result = StockRegister.new(params).exit

      expect(result.quantity).to eq(0)
    end

    xit 'whose result would be negative' do
      @user = FactoryBot.create(:user)
      item = FactoryBot.create(:item, quantity: 0)
      params = { item: item, options: { quantity: 2, user: @user } }

      expect { StockRegister.new(params).exit }
        .to raise_error(ActionController::BadRequest).with_message("Erro: O resultado desta retirada seria negativo!")
    end

    it 'counting with negative quantity' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: { quantity: -2, user: @user } }
      result = StockRegister.new(params).exit

      expect(result).to be_nil
    end

    it 'with zero quantity' do
      item = FactoryBot.create(:item, quantity: 2)
      params = { item: item, options: { quantity: 0, user: @user } }
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
        params = { item: item, options: { quantity: 2, user: @user } }
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
        params = { item: item, options: { quantity: 2, user: @user } }
        result = StockRegister.new(params).exit

        expect(result).to be_nil
      end
    end
  end
end
