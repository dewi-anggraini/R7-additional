require 'faker'
FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name } #I put out the "f"from the factory definition 
    last_name { Faker::Name.last_name }
    phone { Faker::Number.number(digits: 10) }
    email { Faker::Internet.email }    
  end
end

