require 'byebug'

FactoryGirl.define do
  factory :user do
    username  "test"
    email "test@test.com"
    password "123123"
    password_confirmation { |u| u.password }  
    
    callback :before_create do
    	# never require email upon factory creation (s. devise docs):
  		User.email_is_required = false
  	end
  end
  
  sequence :location_name 
  
  factory :location do
    sequence(:name) do |n|
      "Default-#{n}"
    end
  end
  
  factory :article_source do
  	name "user_generated"
  end
  
  factory :producer do
  	name "Rama"
  end
  
  factory :article do  	
  	name "Butter"
  	barcode "123"
  	
  	# assocs:
  	producer
  	association :source, factory: :article_source
  end
end