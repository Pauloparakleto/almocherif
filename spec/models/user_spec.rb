require 'rails_helper'

RSpec.describe User, type: :model do
  context "when create" do
    it "valid" do
      email = Faker::Internet.email
      user = FactoryBot.create(:user, email: email)
      expect(user).to be_truthy
      expect(user.email).to eq(email)
      end

  end
  context "when delete" do
    it "raise error" do
      email = Faker::Internet.email
      user = FactoryBot.create(:user, email: email)
      expect{user.destroy}.to raise_error(ActiveRecord::ActiveRecordError).with_message("Aqui não cidadão!")
    end
  end
end
