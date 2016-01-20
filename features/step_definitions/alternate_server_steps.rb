INDEX_ALTERNATE_SERVERS_PATH = '/alternate_servers'

Before do |scenario|
  @alternateServerHelper = CucumberAlternateServerHelpers::AlternateServerHelper.new
end

Given /^there exist several servers$/ do
  @alternateServerHelper.existing_servers
end

When /^I try to retrieve the index of alternate servers$/ do
  @jsonHelper.json_get INDEX_ALTERNATE_SERVERS_PATH
end

Then /^I should have received those servers$/ do
  result = JSON.parse(@jsonHelper.last_response.body)
  expect(result).to have_key('alternate_servers')
  
  servers_arr = @alternateServerHelper.remember_existing_servers('those servers')
  found_entries_count = 0
  servers_arr.each do |expected_server|
    result['alternate_servers'].each do |server|
      if  expected_server.name == server['name'] \
          and expected_server.description == server['description'] \
          and expected_server.url == server['url']
        found_entries_count += 1
        break
      end
    end
  end
  
  expect(found_entries_count).to be(servers_arr.count)
end