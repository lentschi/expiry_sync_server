Before do |scenario|
  @authHelper = CucumberAuthHelpers::AuthHelper.new
end

When /^I submit the registration form on the website with valid data$/ do
  visit "/"
  click_link "sign up"
  
  user = @authHelper.new_user
  
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  fill_in "Password confirmation", with: user.password
  fill_in "Email", with: user.email
  
  click_button "Sign up"
end

Then /^I should see that registration succeeded$/ do
  expect(page).to have_content('Welcome! You have signed up successfully.')
end

Then /^I should see that I am logged in with that user$/ do
  that_user = @authHelper.remember_new_user("that user")
  expect(page).to have_content("logged in as #{that_user.email.nil? ?that_user.username : that_user.email}")
end

Given /^I am logged in with that user in my web browser$/ do
  that_user = @authHelper.remember_existing_user("that user")
  
  visit "/"
  click_link "login"
  
  fill_in "Login", with: that_user.email.nil? ?that_user.username : that_user.email
  fill_in "Password", with: that_user.password
  
  click_button "login"
  expect(page).to have_content("logged in as #{that_user.email.nil? ?that_user.username : that_user.email}")
end