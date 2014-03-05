# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.first

category_1 = Category.create(user: user, title: 'Work', color: rgb(192, 57, 43))

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

#Client Calls - Happens frequently throughout the week, relatively similar amounts of time for each occurrence
event_14 = Event.create(tag: tag_4, started_at: Time.at(1392037200), ended_at: Time.at(1392040800), duration: 60)
event_15 = Event.create(tag: tag_4, started_at: Time.at(1392055200), ended_at: Time.at(1392066000), duration: 180)
event_16 = Event.create(tag: tag_4, started_at: Time.at(1392123600), ended_at: Time.at(1392134400), duration: 180)
event_17 = Event.create(tag: tag_4, started_at: Time.at(1392145200), ended_at: Time.at(1392151500), duration: 105)
event_18 = Event.create(tag: tag_4, started_at: Time.at(), ended_at: Time.at(), duration: )
