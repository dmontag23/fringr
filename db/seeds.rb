# Create users
User.create!(name:  "Example User",
             email: "example@example.com",
             password:              "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)
5.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.com"
  User.create!(name:  name,
              email: email,
              password:              "password",
              password_confirmation: "password",
              activated: true,
              activated_at: Time.zone.now)
end

# Create locations
user = User.first
5.times do
  content = Faker::GameOfThrones.city
  user.locations.create!(name: content)
end

# Create contacts
user = User.first
50.times do
  name_content = Faker::GameOfThrones.character
  email_content = Faker::Internet.email
  user.contacts.create!(name: name_content, email: email_content)
end

# Create schedules
user = User.first
5.times do
  name_content = Faker::GameOfThrones.house
  number_content = Faker::Number.between(1, 12) * 5
  user.schedules.create!(name: name_content, actor_transition_time: number_content, days_attributes: [ 
                                                  { start_time: Time.zone.parse('2016-04-08 7:00pm'), end_time: Time.zone.parse('2016-04-08 10:00pm') },
                                                  { start_time: Time.zone.parse('2016-04-09 7:00pm'), end_time: Time.zone.parse('2016-04-09 10:00pm') }
                                                ])
end

def populate_conflict_data
  @description_content = Faker::Lorem.word
  @start_time_content = rand(5.weeks).seconds.ago
  @end_time_content = rand(2.days).seconds.from_now
end

# Create conflicts for contacts
User.first.contacts.each do |contact|
  populate_conflict_data
  contact.conflicts.create!(description: @description_content, start_time: @start_time_content, end_time: @end_time_content)
end

# Create conflicts for locations
User.first.locations.each do |location|
  populate_conflict_data
  location.conflicts.create!(description: @description_content, start_time: @start_time_content, end_time: @end_time_content)
end

# Create pieces for a schedule
schedule = User.first.schedules.first
21.times do
  title_content = Faker::Lorem.word
  length_content = Faker::Number.between(1, 12) * 5
  setup_content = Faker::Number.between(1, 4) * 5
  cleanup_content = Faker::Number.between(1, 4) * 5
  location_content = Faker::Number.between(1, 5)
  rating_content = Faker::Number.between(1, 4)
  mycount_content = Faker::Number.between(1, 2)
  first_content = Faker::Number.between(1, 50)
  second_content = Faker::Number.between(1, 50)
  third_content = Faker::Number.between(1, 50)
  piece = schedule.pieces.build(title: title_content, length: length_content, setup: setup_content , 
    cleanup: cleanup_content, location_id: location_content, rating: rating_content, mycount: mycount_content,
    contact_ids: [first_content, second_content, third_content])
  mycount_content.to_i.times {piece.scheduled_times.build}
  piece.save!
end