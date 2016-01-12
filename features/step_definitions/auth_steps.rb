SIGN_IN_PATH = "/users/sign_in"
SIGN_OUT_PATH = "/users/sign_out"
REGISTER_PATH = "/users"
UPDATE_USER_PATH = "/users"
DELETE_USER_PATH = "/users"

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

When /^I perform a login with (that user's|invalid login) data(?: using their (.+) as login key)?(?: specifying the (new|old) password)?$/ do |login_data_str, login_key_str, specify_new_pwd_str|
  user = (login_data_str == "that user's") ? @authHelper.remember_existing_user('that user') : @authHelper.invalid_user
   
  @authHelper.sign_in_params = {
    user: {
      password: specify_new_pwd_str.nil? ? user.password : ((specify_new_pwd_str == 'old') ? @authHelper.old_password : @authHelper.sign_in_params[:user][:password])
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
  when 'with valid data but without an email address'
    new_user.email = nil
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

Given /^I just registered a new user$/ do
  step "I try to register with valid data"
  step "the call should be successful"
  step "I should have received a valid access token"
end


When /^I try to update that user (.+)$/ do |with_what_data_str|
  the_user = @authHelper.remember_logged_in_user("Don't know what you mean by 'that user'")
  
  params = {
    user: {
      username: the_user.username,
      id: the_user.id 
    }
  }
  
  case with_what_data_str
  when 'with an email address and a new password'
    params[:user][:email] = 'somevalidaddress@bla.com'
    @authHelper.old_password = params[:user][:current_password] = '123123' # TODO: define this as a constant
    params[:user][:password] = 'somenewvalidpwd'
  when 'with a new username'
    params[:user][:username] = 'somenewvalidusername'
  when 'without an email address'
    @authHelper.old_password = params[:user][:current_password] = '123123' # TODO: define this as a constant
    params[:user][:password] = 'somenewvalidpwd'
  end
  @jsonHelper.json_put UPDATE_USER_PATH, params

  @authHelper.sign_in_params = {
    user: {
      username: params[:user][:username].nil? ? the_user.username : params[:user][:username],
      password: 'somenewvalidpwd'
    }
  }  
end

When /^I logout$/ do 
  @jsonHelper.json_delete SIGN_OUT_PATH
end

When(/^I try to deactivate my account$/) do
  the_user = @authHelper.remember_logged_in_user("Don't know what you mean by 'my account'")
  @jsonHelper.json_delete "#{DELETE_USER_PATH}"
  
  @authHelper.deactivated_user = the_user
end

When(/^the deactivated user's record is manually reactivated in the db$/) do
  the_user = @authHelper.remember_deactivated_user("Don't know what you mean by 'the deactivated user'")
  the_user.restore!
end


