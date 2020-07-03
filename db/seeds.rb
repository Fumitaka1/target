# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# cording: UTF-8require 'i18n'
I18n.locale = :ja
require 'faker'
Faker::Config.locale = :ja
Faker::Internet.email # => "ransom_blanda@auer.name"

User.create!(name: 'admin', email: 'admin@rotine.com', password: 'admins-password', admin: true)
100.times do |no|
  User.create!(name: "#{Faker::Name.name}@#{Faker::Job.position} #{no}",
               email: Faker::Internet.email,
               password: 'a' * 8)
end

100.times do |no|
  Post.create!(title: Faker::Lorem.sentence, content: Faker::Lorem.sentence(word_count: 10), user_id: Random.rand(100)+1)
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
