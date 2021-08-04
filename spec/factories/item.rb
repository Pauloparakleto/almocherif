FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    quantity { Faker::Number.number(digits: 2) }
  end
end
