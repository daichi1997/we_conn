FactoryBot.define do
  factory :user do
    name                  { Faker::Lorem.characters(number: rand(2..10)) }
    email                 { Faker::Internet.email }
    password              { 'test1234' }
    password_confirmation { password }
  end
end
