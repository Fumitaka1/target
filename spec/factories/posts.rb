# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user
    sequence(:title) { |i| "post No.#{i}" }
    sequence(:content) { |i| "content No.#{i}" }
  end
end
