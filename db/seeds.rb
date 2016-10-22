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