FactoryBot.define do
  factory :event do
    title { "Sample Event" }
    description { "This is a sample event description" }
    start_time { 1.week.from_now }
    location { "Sample Location" }
    association :user
    association :tag

    # basic_info ステップのデータ
    trait :basic_info do
      title { "Basic Info Event" }
      description { "Description for basic info event" }
      association :tag
    end

    # date_and_location ステップのデータ
    trait :with_date_and_location do
      start_time { 2.weeks.from_now }
      location { "Specific Location" }
    end

    # image_upload ステップのデータ (画像は任意なので、トレイトは必要に応じて)
    trait :with_image do
      after(:build) do |event|
        event.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'sample_image.jpg')), filename: 'sample_image.jpg', content_type: 'image/jpeg')
      end
    end

    # 全ステップのデータを含むイベント
    factory :complete_event do
      basic_info
      with_date_and_location
      with_image
    end
  end
end