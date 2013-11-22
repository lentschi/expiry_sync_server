module CucumberAuthHelpers
  class AuthHelper
    include RSpec::Matchers
    
    attr_accessor :existing_user, :other_user, :invalid_user, :logged_in_user, :sign_in_params
        
    def remember_existing_user(reference)
      @existing_user.should_not be_nil, TestHelper.reference_error_str(reference)
      @existing_user
    end
    
    def other_user
      @other_user ||= FactoryGirl.create(:user, email: 'other@alia.com', password: 'correct')
    end
    
    def invalid_user
      @invalid_user ||= FactoryGirl.build(:user, email: 'invalid@wrong.com', password: 'wrong')
    end
    
    def remember_logged_in_user(error_msg="No 'current user'")
      @logged_in_user.should_not be_nil, error_msg
      @logged_in_user
    end
  end
end

World(CucumberAuthHelpers)