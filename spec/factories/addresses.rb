# -*- coding: utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address do
    sequence(:addr) {|n| "#{n} street"}
    designation "Home"
    zip_code "75017"
    country "France"
    state "îles de france"
    city "Paris"
  end
end
