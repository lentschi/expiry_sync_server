FactoryGirl.define do
  factory :user do
    username  "test"
    email "test@test.com"
    password "123123"
    password_confirmation { |u| u.password }  
  end
  
  sequence :location_name 
  
  factory :location do
    sequence(:name) do |n|
      "Default-#{n}"
    end
  end
end