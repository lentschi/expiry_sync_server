FactoryGirl.define do
  factory :user do
    email "test@test.com"
    password "123123"
    password_confirmation { |u| u.password }  
  end
  
  factory :location do
    name "Default"
  end
end