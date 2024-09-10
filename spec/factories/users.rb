FactoryBot.define do
  factory :user do
    name { "#{Faker::Name.last_name}#{Faker::Name.first_name}" }
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
