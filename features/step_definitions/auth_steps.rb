require 'debugger'

SIGN_IN_PATH = "/users/sign_in"

Before do |scenario|
  @authHelper = CucumberAuthHelpers::AuthHelper.new
end

#Given /^the following users exist:$/ do |user_rows|
#  user_rows.hashes.each do |attributes|
#    attribs = attributes.merge(:password_confirmation => attributes[:password])
#    FactoryGirl.create(:user, attribs)
#  end
#end

Given /^a valid user exists$/ do
  @authHelper.existing_user ||= FactoryGirl.create :user
end

Given /^I am logged in with that user$/ do
  # TODO: Make this non-step calls:
  step "I perform a login with that user's data"
  step "the call should be successful"
  step "I should have received a valid access token"
end

When /^I perform a login with (that user's|invalid login) data$/ do |login_data_str|
  user = (login_data_str == "that user's") ? @authHelper.remember_existing_user('that user') : @authHelper.invalid_user
   
  @authHelper.sign_in_params = {
    user: {
      username: user.username,
      password: user.password
    }
  }
  
  json_post SIGN_IN_PATH, @authHelper.sign_in_params
end

Then /^I should have received a valid access token$/ do
  set_cookie_header = last_response.header["Set-Cookie"]
  set_cookie_header.should match(/bbw_server_session=.+;/)
  #TODO: Check if this cannout be done more accurately
  
  
  @authHelper.logged_in_user = User.find_by_username(@authHelper.sign_in_params[:user][:username])
end

When /^I try to register (.+)$/ do |in_which_way_str|
  case in_which_way_str
  when 'omitting my first name'
    raise Cucumber::Undefined.new("TODO too'")
  else
    raise Cucumber::Undefined.new("No such way to register in: '#{in_which_way_str}'")
  end  
end