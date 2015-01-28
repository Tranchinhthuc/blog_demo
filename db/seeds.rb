# Users
User.create!(name:  "Tran Thuc",
             email: "thuctc91@gmail.com",
             password:              "thuc1991",
             password_confirmation: "thuc1991",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end

# Entries
users = User.order(:created_at).take(6)
50.times do
 body = Faker::Lorem.sentence(5)
 users.each { |user| user.entries.create!(body: body) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
