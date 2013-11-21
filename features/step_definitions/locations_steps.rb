require 'debugger'

ADD_PATH = '/locations'
DELETE_PATH = '/locations'
INDEX_MINE_CHANGED_PATH = '/locations/index_mine_changed'

VALID_LOCATION_DATA = [
  {name: "Default"}
]

def valid_location_data
  VALID_LOCATION_DATA[0]
end

def location(reference='that location')
  @location.should_not be_nil, reference_error_str(reference)
  @location
end

def locations_list(reference='the list')
  @locations_list.should_not be_nil, reference_error_str(reference)
  @locations_list
end

When /^I try to add a location with valid data$/ do
  params = {
    location: {
      name: valid_location_data[:name]
    }
  }
    
  json_post ADD_PATH, params
end

Then /^I should have received a valid location$/ do
  result = JSON.parse(last_response.body)
  
  verify_contained_obj_integrity result, "location"
  result["location"].should have_key("name")
  
  @location = FactoryGirl.build(:location, result["location"])
end

Given /^a location (created by (.+) )?is (not )?assigned to me$/ do |_, creator_str, assigned_str|
  # Parse params:  
  assigned_to_me = assigned_str.nil?
  created_by_me = case creator_str
  when nil
    assigned_to_me
  when 'me'
    true
  when 'someone else'
    false
  else
    raise Cucumber::Undefined.new("No such creator: '#{creator_str}'")
  end
  
   
  # fake other creator:
  other_user.make_current unless created_by_me
   
  # create the location: 
  @location = FactoryGirl.create(:location, valid_location_data)
  @location.users << (assigned_to_me ? logged_in_user : other_user)
  @location.save
  
  # cleanup (undo creator fake):
  logged_in_user.make_current unless created_by_me
end

When /^I try to delete that location$/ do
  json_delete DELETE_PATH + "/#{location.id}"
end

When /^I request a list of my locations$/ do
  json_get INDEX_MINE_CHANGED_PATH#, last_change: nil
end

Then /^I should have received a valid location list/ do
  result = JSON.parse(last_response.body)
  
  result.should have_key('locations')
  result['locations'].should be_a_kind_of(Array)  
  result['locations'].each do |location_hash|
    verify_obj_integrity location_hash, 'location'
    location_hash.should have_key('deleted_at')
    location_hash['deleted_at'].should be_nil
  end
  
  result.should have_key('deleted_locations')
  result['deleted_locations'].should be_a_kind_of(Array)
  result['deleted_locations'].each do |location_hash|
    verify_obj_integrity location_hash, 'location'
    location_hash.should have_key('deleted_at')
    location_hash['deleted_at'].should_not be_nil
  end
  
  @locations_list = {locations: result['locations'], deleted_locations: result['deleted_locations']}
end

Then /^(.+) location should be in the list (marked as (deleted|existing))$/ do |location_str,_, marked_as|
  found = nil
  
  the_location = case location_str
  when 'the previously deleted'
    location('previously deleted location')
  else
    raise Cucumber::Undefined.new("No such location: '#{location_str}'")
  end
  
  (locations_list[:locations] + locations_list[:deleted_locations]).each do |location_hash|
    if Integer(location_hash['id']) == the_location.id
      found = location_hash
    end
  end
  
  found.should_not be_nil, 'Previously deleted location not in list'
  
  case marked_as
  when 'deleted'
    found['deleted_at'].should_not be_nil
  when 'existing'
    found['deleted_at'].should be_nil
  end
end