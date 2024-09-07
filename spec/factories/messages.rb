FactoryBot.define do
  factory :message do
    content { "MyText" }
    user { nil }
    chat_room { nil }
  end
end
