require 'spec_helper'

feature 'User views Routine page' do
	background do
		user = create(:user)
		category = create(:category, user: user)
		3.times do |i|
			create(:tag, name: "tag_can_not_show", category: category)
			create(:tag, routine: i+1, name: "tag_#{i+1}", category: category)
		end
		sign_in_as(user)
		visit '/routines'
	end
	scenario 'sorted by routine value' do
		expect(page).to have_content(/tag_1.*tag_2.*tag_3/)
		expect(page).to_not have_content('tag_can_not_show')
	end
end

