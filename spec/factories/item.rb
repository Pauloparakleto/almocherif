FactoryBot.define do
  factory :item do
    name { Faker::Commerce.unique.product_name }
    quantity { Faker::Number.number(digits: 2) }
  end
end
