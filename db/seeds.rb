# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a main sample user.
User.create!(
  name: "Fernando Conde",
  email: "ferconde87@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true,
  activated: true,
  activated_at: 1.minute.ago)

# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "#{name.split[0]}-#{n+1}@example.com"
  password = "password"
  User.create!(
    name: name, 
    email: email, 
    password: password, 
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end
  
# Generate posts for a subset of users.
users = User.order(:created_at).take(6)
users.each do |user| 
  rand(40..60).times do
    content = Faker::Lorem.sentence(word_count: rand(5..30))
    user.posts.create!(content: content, created_at: rand(1..200).hours.ago)
  end 
end

# Create following relationships.
users = User.all
user = users.first #fer
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Create likes and dislikes
users = User.order(:created_at).take(20)
posts_number = 40
posts = Post.order(:created_at).take(posts_number)
users.each do |user|
  rand(20..posts_number).times do |index|
    random_index = rand(posts_number)
    Like.like(user, posts[random_index]) unless Like.like?(user, posts[random_index])
  end
end

users.each do |user|
  rand(1..posts_number).times do |index|
    random_index = rand(posts_number)
    if !Like.like?(user, (posts[random_index])) && !Like.dislike?(user, posts[random_index])
      Like.dislike(user, posts[index])
    end
  end
end

# Create comments on posts
users.each do |user|
  rand(10..40).times do
    random_index = rand(posts_number)
    content = Faker::Lorem.sentence(word_count: rand(1..20))
    seconds_ago = Time.now - posts[random_index].created_at
    created_at = rand(1..seconds_ago).seconds.ago
    user.comments.create!(post: posts[random_index], content: content, created_at: created_at)
  end
end

# Create likes and dislikes for comments
comments_number = 100
comments = Comment.order(:created_at).take(comments_number)
users.each do |user|
  rand(40..comments_number).times do
    random_index = rand(comments_number)
    Like.like(user, comments[random_index]) unless Like.like?(user, comments[random_index])
  end
end

users.each do |user|
  rand(10..comments_number).times do |index|
    random_index = rand(comments_number)
    if !Like.like?(user, (comments[random_index])) &&  !Like.dislike?(user, comments[random_index])
      Like.dislike(user, comments[index])
    end
  end
end
