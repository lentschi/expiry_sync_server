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
  	
  	# Don't create many sources, just because many articles might be created:
  	initialize_with do
  		ArticleSource.find_or_create_by(name: name)
  	end
  end
  
  factory :producer do
  	sequence(:name) do |n|
      "Unilever-#{n}"
    end
  end
  
  factory :article do  	
  	name "Butter"
  	barcode "123"
  	
  	# assocs:
  	producer
  	association :source, factory: :article_source
  end
  
  factory :product_entry do
  	description "mmmh"
  	amount 1
  	
  	# assocs:
  	article
  	location
  end
end