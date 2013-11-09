require 'debugger'

Given /^the following users exist:$/ do |user_rows|
  user_rows.hashes.each do |attributes|
    attribs = attributes.merge(:password_confirmation => attributes[:password])
    FactoryGirl.create(:user, attribs)
  end
end

def set_json_request_header!
  header 'Accept', "application/json"
  header 'Content-Type', "application/json"
end

def json_request(path, request_opts)
  set_json_request_header!
  request path, request_opts
end

def json_post(path, params)
  request_opts = {
    method: 'POST',
    input: params.to_json
  }
  
  json_request path, request_opts
end

When /^I perform an API login with:$/ do |user_rows|
  attributes = user_rows.hashes[0]
    
  params = {
    user: {
      email: attributes[:email],
      password: attributes[:password]
    }
  }
  
  json_post "/users/sign_in", params
end

Then /^the API call should be successful$/ do
  result = JSON.parse(last_response.body)
  result["status"].should == 'success'
end

Then /^I should have received a valid access token$/ do
  set_cookie_header = last_response.header["Set-Cookie"]
  set_cookie_header.should match(/bbw_server_session=.+;/)
  #TODO: Check if this cannout be done more accurately
end