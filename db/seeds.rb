# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

category_1 = Category.create(user_id: 1, title: 'work')
category_2 = Category.create(user_id: 1, title: 'home')
category_2 = Category.create(user_id: 1, title: 'personal')

tag_1 = Tag.create(name: 'work_tag_1', category: category_1)
tag_2 = Tag.create(name: 'work_tag_2', category: category_1)
tag_3 = Tag.create(name: 'work_tag_3', category: category_1)
tag_4 = Tag.create(name: 'home_tag_1', category: category_2)
tag_5 = Tag.create(name: 'home_tag_2', category: category_2)
tag_6 = Tag.create(name: 'home_tag_3', category: category_2)
tag_7 = Tag.create(name: 'personal_tag_1', category: category_3)
tag_8 = Tag.create(name: 'personal_tag_2', category: category_3)
tag_9 = Tag.create(name: 'personal_tag_3', category: category_3)

