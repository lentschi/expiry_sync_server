Before do |scenario|
  @alternateServerHelper = CucumberAlternateServerHelpers::AlternateServerHelper.new
end

When /^I submit the creation form for an alternate server on the website (providing all data|omitting the name|omitting the description|omitting name and description|omitting the url|with an url that has been used before|with an invalid url)$/ do |providing_str|
  visit "/"
  click_link "alternate servers"
  click_link "new alternate server"
  
  server = @alternateServerHelper.new_alternate_server
  
  case providing_str
  when 'omitting the name'
    server.name = nil
  when 'omitting the description'
    server.description = nil
  when 'omitting name and description'
    server.name = server.description = nil
  when 'omitting the url'
    server.url = nil
  when 'with an url that has been used before'
    other_server = FactoryGirl.create(:alternate_server)
    server.url = other_server.url
  when 'with an invalid url'
    server.url = '##invalid##'
  end
  
  fill_in "URL", with: server.url
  fill_in "Name (en)", with: server.name
  fill_in "Description (en)", with: server.description
  
  click_button "add alternate server"
end

Then /^I should see that the creation of the server succeeded$/ do
  expect(page).to have_content('successfully created an alternate server')
end

Then /^I should see that the creation of the server failed$/ do
  expect(page).to have_content('prohibited this form from being saved')
end

Then(/^I should see that server in the server list$/) do
  that_server = @alternateServerHelper.remember_new_alternate_server('that server')
  expect(page).to have_content(that_server.name)
end
 
When /^I open the server list on the website$/ do
  visit "/"
  click_link "alternate servers"
end

Then /^I should see those servers$/ do
  servers_arr = @alternateServerHelper.remember_existing_servers('those servers')
  servers_arr.each do |expected_server|
     expect(page).to have_content(expected_server.url)
     expect(page).to have_content(expected_server.name)
     expect(page).to have_content(expected_server.description)
  end
end
