# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "===Módulo Item====="
FactoryBot.create(:user, email: "user-sheriff@gmail.com", password: "123456", password_confirmation: "123456")
FactoryBot.create(:user, email: "user-2-sheriff@gmail.com", password: "123456", password_confirmation: "123456")
FactoryBot.create_list(:item, 50)
