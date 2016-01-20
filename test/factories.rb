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
  	sequence(:name) do |n|
      "Butter-#{n}"
    end
    
    sequence(:barcode) do |n|
      "123#{n}"
    end
  	
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
  
  factory :alternate_server do    
    sequence(:name) do |n|
      "My alternate server-#{n}"
    end
    
    sequence(:url) do |n|
      "https://my-fancy-alternate-server-#{n}.com"
    end
    
    sequence(:description) do |n|
      "connects you to a huge barcode database-#{n}"
    end
  end
end