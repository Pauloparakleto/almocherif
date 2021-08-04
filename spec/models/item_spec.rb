require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'should create' do
    item = FactoryBot.create(:item)
    expect(item).to be_truthy
  end
end
