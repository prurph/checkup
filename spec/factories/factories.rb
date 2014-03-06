FactoryGirl.define do
  sequence(:name) { |n| "#{Faker::Lorem.word} #{n}" }
  sequence(:email) { |n| "#{Faker::Internet.email}#{n}" }
  sequence(:color) do |n|
    ["#27ae60", "#2980b9", "#d35400", "#f39c12", "#8e44ad"][(n % 5)]
  end

  sequence(:title) do |n|
    "#{Faker::Lorem.word} #{n}"
    #["Work", "Personal", "Goals", "Family"][n % 4]
  end

  factory :user do
    email
    password { Faker::Lorem.words(5).join }
  end

  factory :category do
    user
    title
    active { true }
    inactive_at { nil }
    color
  end

  factory :tag do
    category
    active { true }
    name
  end

  factory :event do
    tag
    duration { rand(300...28800) } # 5 minutes - 8 hours in seconds
  end
end
