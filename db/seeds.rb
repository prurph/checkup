# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(email: "user@example.com", password: "foobar55",
  password_confirmation: "foobar55", created_at: Time.at(1387724400))

user.categories.destroy_all
category_1 = Category.create(user: user, title: 'Work', color: "41,128,185")

tag_1 = Tag.create(category: category_1, name: 'Commute')
tag_2 = Tag.create(category: category_1, name: 'Team Meetings')
tag_3 = Tag.create(category: category_1, name: 'Business Lunches')
tag_4 = Tag.create(category: category_1, name: 'Client Calls')

#Commute tag - Regular Event happens at a similar time every day
#Going to work every day assuming a M-F work week
#Duration is in minutes
event_1 = Event.create(tag: tag_1, started_at: Time.at(1392030023), ended_at: Time.at(1392034523), duration: 75)
event_2 = Event.create(tag: tag_1, started_at: Time.at(1392116603), ended_at: Time.at(1392120623), duration: 67)
event_3 = Event.create(tag: tag_1, started_at: Time.at(1392203723), ended_at: Time.at(1392207323), duration: 60)
event_4 = Event.create(tag: tag_1, started_at: Time.at(1392289163), ended_at: Time.at(1392292763), duration: 60)
event_5 = Event.create(tag: tag_1, started_at: Time.at(1392375923), ended_at: Time.at(1392380423), duration: 75)
#Coming back from work every day assuming a M-F work week
event_6 = Event.create(tag: tag_1, started_at: Time.at(1392069600), ended_at: Time.at(1392073200), duration: 60)
event_7 = Event.create(tag: tag_1, started_at: Time.at(1392156780), ended_at: Time.at(1392161580), duration: 80)
event_8 = Event.create(tag: tag_1, started_at: Time.at(1392240780), ended_at: Time.at(1392244980), duration: 70)
event_9 = Event.create(tag: tag_1, started_at: Time.at(1392331380), ended_at: Time.at(1392335820), duration: 74)
event_10 = Event.create(tag: tag_1, started_at: Time.at(1392415440), ended_at: Time.at(1392420840), duration: 90)

#Team Meetings tag - Happens a few times a week, but the length of the event varies
event_11 = Event.create(tag: tag_2, started_at: Time.at(1392042600), ended_at: Time.at(1392046200), duration: 60)
event_12 = Event.create(tag: tag_2, started_at: Time.at(1392318000), ended_at: Time.at(1392326700), duration: 145)

#Business Lunches tag - Happens infrequently. for this example week, it occurs just once
event_13 = Event.create(tag: tag_3, started_at: Time.at(1392397200), ended_at: Time.at(1392402600), duration: 90)

#Client Calls - Happens frequently throughout the week, varying amounts of time for each occurrence
event_14 = Event.create(tag: tag_4, started_at: Time.at(1392037200), ended_at: Time.at(1392040800), duration: 60)
event_15 = Event.create(tag: tag_4, started_at: Time.at(1392055200), ended_at: Time.at(1392066000), duration: 180)
event_16 = Event.create(tag: tag_4, started_at: Time.at(1392123600), ended_at: Time.at(1392134400), duration: 180)
event_17 = Event.create(tag: tag_4, started_at: Time.at(1392145200), ended_at: Time.at(1392151500), duration: 105)

event_18 = Event.create(tag: tag_4, started_at: Time.at(1392210000), ended_at: Time.at(1392217200), duration: 120)
event_19 = Event.create(tag: tag_4, started_at: Time.at(1392234300), ended_at: Time.at(1392238800), duration: 75)
event_20 = Event.create(tag: tag_4, started_at: Time.at(1392300000), ended_at: Time.at(1392308700), duration: 145)
event_21 = Event.create(tag: tag_4, started_at: Time.at(1392327000), ended_at: Time.at(1392328800), duration: 30)
event_22 = Event.create(tag: tag_4, started_at: Time.at(1392386400), ended_at: Time.at(1392389100), duration: 45)
event_23 = Event.create(tag: tag_4, started_at: Time.at(1392406200), ended_at: Time.at(1392411600), duration: 90)


category_2 = Category.create(user: user, title: 'Personal', color: "39,174,96")

tag_5 = Tag.create(category: category_2, name: 'Shopping')
tag_6 = Tag.create(category: category_2, name: 'Gym')
tag_8 = Tag.create(category: category_2, name: 'Sleep')
tag_10 = Tag.create(category: category_2, name: 'Meals')

event_24 = Event.create(tag: tag_5, started_at: Time.at(1392476400), ended_at: Time.at(1392494400), duration: 300)
event_25 = Event.create(tag: tag_5, started_at: Time.at(1392577200), ended_at: Time.at(1392588000), duration: 180)

event_26 = Event.create(tag: tag_6, started_at: Time.at(1392048000), ended_at: Time.at(1392051600), duration: 60)
event_27 = Event.create(tag: tag_6, started_at: Time.at(1392152400), ended_at: Time.at(1392156000), duration: 60)
event_28 = Event.create(tag: tag_6, started_at: Time.at(1392220800), ended_at: Time.at(1392224400), duration: 60)
event_29 = Event.create(tag: tag_6, started_at: Time.at(1392294600), ended_at: Time.at(1392298200), duration: 60)
event_30 = Event.create(tag: tag_6, started_at: Time.at(1392381000), ended_at: Time.at(1392384600), duration: 60)

event_32 = Event.create(tag: tag_8, started_at: Time.at(1392001200), ended_at: Time.at(1392026400), duration: 420)
event_33 = Event.create(tag: tag_8, started_at: Time.at(1392087600), ended_at: Time.at(1392112800), duration: 420)
event_34 = Event.create(tag: tag_8, started_at: Time.at(1392174000), ended_at: Time.at(1392199200), duration: 420)
event_35 = Event.create(tag: tag_8, started_at: Time.at(1392260400), ended_at: Time.at(1392285600), duration: 420)
event_36 = Event.create(tag: tag_8, started_at: Time.at(1392346800), ended_at: Time.at(1392372000), duration: 420)
event_37 = Event.create(tag: tag_8, started_at: Time.at(1392433200), ended_at: Time.at(1392458400), duration: 420)
event_38 = Event.create(tag: tag_8, started_at: Time.at(1392519600), ended_at: Time.at(1392544800), duration: 420)

event_42 = Event.create(tag: tag_10, started_at: Time.at(1392026400), ended_at: Time.at(1392030000), duration: 60)
event_43 = Event.create(tag: tag_10, started_at: Time.at(1392051600), ended_at: Time.at(1392055200), duration: 60)
event_44 = Event.create(tag: tag_10, started_at: Time.at(1392073200), ended_at: Time.at(1392076800), duration: 60)
event_46 = Event.create(tag: tag_10, started_at: Time.at(1392112800), ended_at: Time.at(1392116400), duration: 60)
event_47 = Event.create(tag: tag_10, started_at: Time.at(1392138000), ended_at: Time.at(1392145200), duration: 120)
event_48 = Event.create(tag: tag_10, started_at: Time.at(1392163200), ended_at: Time.at(1392166800), duration: 60)
event_50 = Event.create(tag: tag_10, started_at: Time.at(1392199200), ended_at: Time.at(1392202800), duration: 60)
event_51 = Event.create(tag: tag_10, started_at: Time.at(1392224400), ended_at: Time.at(1392231600), duration: 120)
event_52 = Event.create(tag: tag_10, started_at: Time.at(1392246000), ended_at: Time.at(1392249600), duration: 60)
event_54 = Event.create(tag: tag_10, started_at: Time.at(1392285600), ended_at: Time.at(1392288600), duration: 50)
event_55 = Event.create(tag: tag_10, started_at: Time.at(1392310800), ended_at: Time.at(1392318000), duration: 120)
event_56 = Event.create(tag: tag_10, started_at: Time.at(1392343200), ended_at: Time.at(1392345000), duration: 30)
event_57 = Event.create(tag: tag_10, started_at: Time.at(1392372000), ended_at: Time.at(1392375600), duration: 60)
event_58 = Event.create(tag: tag_10, started_at: Time.at(1392422400), ended_at: Time.at(1392426000), duration: 60)
event_60 = Event.create(tag: tag_10, started_at: Time.at(1392458400), ended_at: Time.at(1392462000), duration: 60)
event_61 = Event.create(tag: tag_10, started_at: Time.at(1392494400), ended_at: Time.at(1392501600), duration: 120)
event_65 = Event.create(tag: tag_10, started_at: Time.at(1392544800), ended_at: Time.at(1392548400), duration: 60)
event_66 = Event.create(tag: tag_10, started_at: Time.at(1392570000), ended_at: Time.at(1392577200), duration: 120)
event_67 = Event.create(tag: tag_10, started_at: Time.at(1392595200), ended_at: Time.at(1392598800), duration: 60)


category_3 = Category.create(user: user, title: 'Vacation', color: "241,196,15")

tag_7 = Tag.create(category: category_3, name: "Bahamas Trip")

event_31 = Event.create(tag: tag_7, started_at: Time.at(1387724400), ended_at: Time.at(1388329200), duration: 10080)


category_4 = Category.create(user: user, title: 'Home', color: "231,76,60")

tag_9 = Tag.create(category: category_4, name: "Housework")

event_39 = Event.create(tag: tag_9, started_at: Time.at(1392076800), ended_at: Time.at(1392084000), duration: 120)
event_40 = Event.create(tag: tag_9, started_at: Time.at(1392249600), ended_at: Time.at(1392256800), duration: 120)
event_41 = Event.create(tag: tag_9, started_at: Time.at(1392336000), ended_at: Time.at(1392343200), duration: 120)
event_64 = Event.create(tag: tag_9, started_at: Time.at(1392501600), ended_at: Time.at(1392508800), duration: 120)
event_68 = Event.create(tag: tag_9, started_at: Time.at(1392552000), ended_at: Time.at(1392559200), duration: 120)

category_5 = Category.create(user: user, title: "Family", color: "230,126,34")

tag_11 = Tag.create(category: category_5, name: "TV")

event_45 = Event.create(tag: tag_11, started_at: Time.at(1392170400), ended_at: Time.at(1392174000), duration: 60)
event_49 = Event.create(tag: tag_11, started_at: Time.at(1392166800), ended_at: Time.at(1392174000), duration: 120)
event_53 = Event.create(tag: tag_11, started_at: Time.at(1392256800), ended_at: Time.at(1392260400), duration: 60)
event_59 = Event.create(tag: tag_11, started_at: Time.at(1392426000), ended_at: Time.at(1392433200), duration: 120)
event_62 = Event.create(tag: tag_11, started_at: Time.at(1392465600), ended_at: Time.at(1392476400), duration: 180)
event_63 = Event.create(tag: tag_11, started_at: Time.at(1392508800), ended_at: Time.at(1392519600), duration: 180)
event_69 = Event.create(tag: tag_11, started_at: Time.at(1392559200), ended_at: Time.at(1392570000), duration: 180)
event_70 = Event.create(tag: tag_11, started_at: Time.at(1392588000), ended_at: Time.at(1392595200), duration: 120)
event_71 = Event.create(tag: tag_11, started_at: Time.at(1392598800), ended_at: Time.at(1392606000), duration: 120)



