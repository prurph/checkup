FactoryGirl.define do

	factory :user do
		email { Faker::Internet.email }
		password 'password'
	end

	factory :category do
		user
		title 'work'
	end

	factory :tag do
		category
	end
end

