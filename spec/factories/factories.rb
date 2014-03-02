FactoryGirl.define do
  sequence(:routine) { |n| n }
  sequence(:name) { |n| "#{Faker::Lorem.word} #{n}" }
  sequence(:email) { |n| "user#{n}@foobar.com" }

  factory :user do
    email
    password { Faker::Lorem.words(5).join }
  end

  factory :category do
    user
    title { ["Work", "Personal", "Goals", "Family"].sample }
    active { true }
    inactive_at { nil }
    color
  end

  factory :tag do
    category
    active { true }
    routine
    name
  end

  factory :event do
    tag
    duration { rand(300...28800) } # 5 minutes - 8 hours in seconds
  end
end
