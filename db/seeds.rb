User.create!(name:  "Example User",
             email: "example@example.com",
             password:              "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.com"
  User.create!(name:  name,
              email: email,
              password:              "password",
              password_confirmation: "password",
              activated: true,
              activated_at: Time.zone.now)
end

user = User.first
50.times do
  content = Faker::GameOfThrones.city
  user.locations.create!(name: content)
end

user = User.first
50.times do
  name_content = Faker::GameOfThrones.character
  email_content = Faker::Internet.email
  user.contacts.create!(name: name_content, email: email_content)
end

user = User.first
21.times do
  name_content = Faker::GameOfThrones.house
  number_content = Faker::Number.between(1,60)
  user.schedules.create!(name: name_content, actor_transition_time: number_content, days_attributes: [ 
                                                  { start_date: Time.now, end_date: Time.now + 180 },
                                                  { start_date: Time.now, end_date: Time.now + 180 },
                                                  { start_date: Time.now, end_date: Time.now + 120 } 
                                                ])
end