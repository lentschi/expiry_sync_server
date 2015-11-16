module CucumberAuthHelpers
  class AuthHelper
    include RSpec::Matchers
    
    attr_accessor :existing_user, :other_user, :invalid_user, :logged_in_user, :deactivated_user, :sign_in_params, :old_password
        
    def remember_existing_user(reference)
      @existing_user.should_not be_nil, TestHelper.reference_error_str(reference)
      @existing_user
    end
    
    def remember_deactivated_user(reference)
      @deactivated_user.should_not be_nil, TestHelper.reference_error_str(reference)
      @deactivated_user
    end
    
    def other_user
      @other_user ||= FactoryGirl.create(:user, username: 'alia', email: 'other@alia.com', password: 'correct')
    end
    
    def new_user
      @new_user ||= FactoryGirl.build(:user, username: 'new', email: 'new@test.com', password: 'correct')
    end
    
    def invalid_user
      @invalid_user ||= FactoryGirl.build(:user, username: 'invalid', email: 'invalid@wrong.com', password: 'wrong')
    end
    
    def remember_logged_in_user(error_msg="No 'current user'")
      @logged_in_user.should_not be_nil, error_msg
      @logged_in_user
    end
  end
end

World(CucumberAuthHelpers)