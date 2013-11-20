require 'debugger'

def existing_user
  @existing_user
end

def invalid_user
  @invalid_user ||= User.new(email: 'invalid@wrong.com', password: 'wrong')
end

#Given /^the following users exist:$/ do |user_rows|
#  user_rows.hashes.each do |attributes|
#    attribs = attributes.merge(:password_confirmation => attributes[:password])
#    FactoryGirl.create(:user, attribs)
#  end
#end

Given /^a valid user exists$/ do
  @existing_user ||= FactoryGirl.create :user
end

Given /^I am logged in with that user$/ do
  step "I perform a login with that user's data"
end

When /^I perform a login with (that user's|invalid login) data$/ do |login_data_str|
  user = (login_data_str == "that user's") ? existing_user : invalid_user
  user.should_not be_nil, "You need to specify what you mean by 'that user' (no preceding 'Given a valid user exists' registered)!"
   
  params = {
    user: {
      email: user.email,
      password: user.password
    }
  }
  
  json_post "/users/sign_in", params
end

Then /^I should have received a valid access token$/ do
  set_cookie_header = last_response.header["Set-Cookie"]
  set_cookie_header.should match(/bbw_server_session=.+;/)
  #TODO: Check if this cannout be done more accurately
end

When /^I try to register (.+)$/ do |in_which_way_str|
  case in_which_way_str
  when 'omitting my first name'
    raise Cucumber::Undefined.new("TODO too'")
  else
    raise Cucumber::Undefined.new("No such way to register in: '#{in_which_way_str}'")
  end  
end