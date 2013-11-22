require 'debugger'

ADD_PATH = '/locations'
DELETE_PATH = '/locations'
UPDATE_PATH = '/locations'
INDEX_MINE_CHANGED_PATH = '/locations/index_mine_changed'

VALID_LOCATION_DATA = [
  {name: "Default"},
  {name: "Test1"},
  {name: "Test2"},
]

INVALID_LOCATION_DATA = {name: ''}

SEVERAL_AMOUNT = 3 # how much are 'several locations'


When /^I try to add a location with valid data(?: using (.+))?$/ do |using_data_str|
  @locations_submitted ||= Array.new
  
  same_name_as_before = false
  case using_data_str
  when nil
    nil # pass
  when 'the same location name as before'
    same_name_as_before = true
    @locations_submitted.should have_at_least(1).items
  else
    raise Cucumber::Undefined.new("No such data to use: '#{using_data_str}'")
  end
  
  location_data = get_valid_location_data()
  params = {
    location: {
      name: same_name_as_before ? @locations_submitted.last[:location][:name] : location_data[:name]
    }
  }
    
  json_post ADD_PATH, params
  
  @locations_submitted << params
end

When /^I try to update that location with( different)? (valid|invalid) data$/ do |different_data_str, valid_str|
  @locations_submitted ||= Array.new
  
  @valid_location_data_counter ||= 0
  unless different_data_str.nil?
    @valid_location_data_counter+= 1
  end
  
  valid = (valid_str=='valid')
  raise Cucumber::Undefined.new("Not implemented: Different AND invalid") unless different_data_str.nil? or valid
    
  location_data = valid ? VALID_LOCATION_DATA[@valid_location_data_counter] : INVALID_LOCATION_DATA
    
  params = {
    location: {
      id: location('that location').id,
      name: location_data[:name]
    }
  }
  
  json_put UPDATE_PATH+'/'+location('that location').id.to_s, params
  
  @locations_submitted << params
end

Then /^I should have received a valid location$/ do
  result = JSON.parse(last_response.body)
  
  verify_contained_obj_integrity result, "location"
  result["location"].should have_key("name")
  
  @locations = [ FactoryGirl.build(:location, result["location"]) ]
end

Given /^(a location|several locations) (?:created by (.+) )?(?:is|are|was|were) (not )?assigned to me$/ do |location_amount_str, creator_str, assigned_str|
  # Parse params:  
  single_location = case location_amount_str
  when 'a location'
    true
  when 'several locations'
    false
  else
    raise Cucumber::Undefined.new("No such amount of locations: '#{location_amount_str}'")
  end
  
  
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
  @locations = Array.new 
  VALID_LOCATION_DATA.each do |location_data|
    cur_location = FactoryGirl.create(:location, location_data)
    cur_location.users << (assigned_to_me ? logged_in_user : other_user)
    cur_location.save
    @locations << cur_location
    
    break if single_location
  end
  
  # cleanup (undo creator fake):
  logged_in_user.make_current unless created_by_me
end

When /^I try to delete that location$/ do
  json_delete DELETE_PATH + "/"+location('that location').id.to_s
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

Then /^(.+) should( not| no longer)? be in the location list(?: marked as (deleted|existing))?$/ do |location_str, negation_str, marked_as_str|  
  the_locations_arr = case location_str
  when 'the previously deleted location'
    [ location('previously deleted location') ]
  when 'the same locations as assigned before'
    locations('same locations as assigned before')
  when 'the location with its new data'
    @locations_submitted.should_not be_nil
    @locations_submitted.should have_at_least(1).items
    @locations_submitted.map { |params| FactoryGirl.build(:location,params[:location]) }
  when 'the location with its old data'
    old_location = location('the location with its old data')
    old_location.id = nil # we don't count the id as 'data'
    [ old_location ]
  else
    raise Cucumber::Undefined.new("No such location(s): '#{location_str}'")
  end
  
  ensure_in_list('the list', the_locations_arr, !negation_str.nil?, marked_as_str)  
end

def get_valid_location_data
  @valid_location_data_counter ||= 0
  location_data = VALID_LOCATION_DATA[@valid_location_data_counter]
  @valid_location_data_counter += 1
  @valid_location_data_counter = 0 if @valid_location_data_counter >= VALID_LOCATION_DATA.length
  
  location_data
end

def location(reference)
  locations(reference).should have(1).items, reference_error_str(reference)
  locations(reference)[0]
end

def locations(reference)
  @locations.should_not be_nil, reference_error_str(reference)
  @locations
end

def locations_list(reference)
  @locations_list.should_not be_nil, reference_error_str(reference)
  @locations_list
end


def ensure_in_list(reference, the_locations_arr, negated, marked_as_str)
  if negated and !marked_as_str.nil?
    raise Cucumber::Undefined.new("Cannot ensure that a location that is not supposed to be there should be marked as '#{marked_as_str}'")
  end 
  
  the_locations_arr.each do |the_location|
      found = nil
      (locations_list(reference)[:locations] + locations_list(reference)[:deleted_locations]).each do |location_hash|
        # only compare the id if we have one (when comparing 'data' we won't have one):
        if (the_location.id.nil? || Integer(location_hash['id']) == the_location.id) \
          and location_hash['name'] == the_location.name
          found = location_hash 
          break
        end
      end
      
      unless negated
        found.should_not be_nil
        
        case marked_as_str
        when 'deleted'
          found['deleted_at'].should_not be_nil
        when 'existing'
          found['deleted_at'].should be_nil
        end
      else
        found.should be_nil
      end
    end
end