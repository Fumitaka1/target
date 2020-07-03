# frozen_string_literal: true

FactoryBot.define do
  factory :bookmark do
    user
    post
  end
end
