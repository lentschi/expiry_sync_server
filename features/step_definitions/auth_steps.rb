require 'debugger'

SIGN_IN_PATH = "/users/sign_in"
REGISTER_PATH = "/users"

Before do |scenario|
  @authHelper = CucumberAuthHelpers::AuthHelper.new
end

Given /^a valid user(?: (with|without) an email address)? exists$/ do |with_email_address_str|
  params = Hash.new
  params[:email] = nil unless with_email_address_str.nil? or with_email_address_str=='with'
  @authHelper.existing_user ||= FactoryGirl.create :user, params
end

Given /^I am logged in with that user$/ do
  # TODO: Make this non-step calls:
  step "I perform a login with that user's data"
  step "the call should be successful"
  step "I should have received a valid access token"
end

When /^I perform a login with (that user's|invalid login) data(?: using their (.+) as login key)?$/ do |login_data_str, login_key_str|
  user = (login_data_str == "that user's") ? @authHelper.remember_existing_user('that user') : @authHelper.invalid_user
   
  @authHelper.sign_in_params = {
    user: {
      password: user.password
    }
  }
  
  @authHelper.sign_in_params[:user][:login] = case login_key_str
  when 'username', nil
    user.username
  when 'email address'
    user.email
  else
    raise Cucumber::Undefined.new("Not aware of that login key: '#{login_key_str}'")
  end
  
  @jsonHelper.json_post SIGN_IN_PATH, @authHelper.sign_in_params
end

Then /^I should have received a valid access token$/ do
  set_cookie_header = @jsonHelper.last_response.header["Set-Cookie"]
  set_cookie_header.should match(/bbw_server_session=.+;/)
  #TODO: Check if this cannout be done more accurately
  
  @authHelper.logged_in_user = User.find_first_by_auth_conditions(login: @authHelper.sign_in_params[:user][:login])
end

When /^I try to register (.+)$/ do |in_which_way_str|
  new_user = (in_which_way_str== 'with invalid data') ? @authHelper.invalid_user : @authHelper.new_user
  
  case in_which_way_str
  when 'with valid data', 'with invalid data'
    nil # pass
  when 'omitting the username'
    new_user.username = nil
  when 'with an invalid username'
    new_user.username = ''
  when 'with an invalid email address'
    new_user.email = 'bui@invalid_'
  else
    raise Cucumber::Undefined.new("No such way to register in: '#{in_which_way_str}'")
  end  
  
  params = {
    user: {
      password: new_user.password
    }
  }
  
  params[:user][:username] = new_user.username unless new_user.username.nil?
  params[:user][:email] = new_user.email unless new_user.email.nil?
    
  @jsonHelper.json_post REGISTER_PATH, params
  
  @authHelper.sign_in_params = params # newly registered users are automatically signed in
end