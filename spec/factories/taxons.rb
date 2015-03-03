FactoryGirl.define do
  factory :taxon do
    sequence(:name) {|n| "Fake taxon #{n}" }
    association :taxonomy
  end
end
