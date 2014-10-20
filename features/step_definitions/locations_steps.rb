ADD_LOCATION_PATH = '/locations'
DELETE_LOCATION_PATH = '/locations'
UPDATE_LOCATION_PATH = '/locations'
INDEX_MY_CHANGED_LOCATIONS_PATH = '/locations/index_mine_changed'

VALID_LOCATION_DATA = [
  {name: "Default"},
  {name: "Test1"},
  {name: "Test2"},
]

INVALID_LOCATION_DATA = {name: ''}

SEVERAL_LOCATION_AMOUNT = 5

CucumberLocationHelpers::LocationHelper.valid_location_data_arr = VALID_LOCATION_DATA

Before do |scenario|
  @locationHelper = CucumberLocationHelpers::LocationHelper.new
end
  
When /^I try to add a location with valid data(?: using (.+))?$/ do |using_data_str|
  @locationHelper.locations_submitted ||= Array.new
  
  same_name_as_before = false
  case using_data_str
  when nil
    nil # pass
  when 'the same location name as before'
    same_name_as_before = true
    @locationHelper.locations_submitted.should have_at_least(1).items
  else
    raise Cucumber::Undefined.new("No such data to use: '#{using_data_str}'")
  end
  
  location_data = @locationHelper.get_valid_location_data()
  params = {
    location: {
      name: same_name_as_before ? @locationHelper.locations_submitted.last[:location][:name] : location_data[:name]
    }
  }
    
  @jsonHelper.json_post ADD_LOCATION_PATH, params
  
  @locationHelper.locations_submitted << params
end

When /^I try to update that location with( different)? (valid|invalid) data$/ do |different_data_str, valid_str|
  @locationHelper.locations_submitted ||= Array.new
  
  @locationHelper.valid_location_data_counter ||= 0
  unless different_data_str.nil?
    @locationHelper.valid_location_data_counter+= 1
  end
  
  valid = (valid_str=='valid')
  raise Cucumber::Undefined.new("Not implemented: Different AND invalid") unless different_data_str.nil? or valid
    
  location_data = valid ? CucumberLocationHelpers::LocationHelper.valid_location_data_arr[@locationHelper.valid_location_data_counter] : INVALID_LOCATION_DATA
    
  params = {
    location: {
      id: @locationHelper.remember_location('that location').id,
      name: location_data[:name]
    }
  }
  
  @jsonHelper.json_put UPDATE_LOCATION_PATH+'/'+@locationHelper.remember_location('that location').id.to_s, params
  
  @locationHelper.locations_submitted << params
end

Then /^I should have received a valid location$/ do
  result = JSON.parse(@jsonHelper.last_response.body)
  
  TestHelper.verify_contained_obj_integrity result, "location"
  result["location"].should have_key("name")
  
  @locationHelper.locations = [ FactoryGirl.build(:location, result["location"]) ]
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
  @authHelper.other_user.make_current unless created_by_me
   
  # create the location:
  @locationHelper.locations = Array.new 
  VALID_LOCATION_DATA.each do |location_data|
    cur_location = FactoryGirl.create(:location, location_data)
    cur_location.users << (assigned_to_me ? @authHelper.remember_logged_in_user : @authHelper.other_user)
    cur_location.save
    @locationHelper.locations << cur_location
    
    break if single_location
  end
  
  # cleanup (undo creator fake):
  @authHelper.logged_in_user.make_current unless created_by_me
end

When /^I try to delete that location$/ do
  @jsonHelper.json_delete DELETE_LOCATION_PATH + "/"+@locationHelper.remember_location('that location').id.to_s
end

When /^I request a list of my locations( specifying the time of that retrieval)?$/ do |specify_time_str|
  params = Hash.new
  params[:from_timestamp] = @locationHelper.remember_last_fetch('that retrieval').to_s unless specify_time_str.nil?
  @jsonHelper.json_get INDEX_MY_CHANGED_LOCATIONS_PATH, params
end

Given /^the client had performed a location retrieval earlier$/ do
  @locationHelper.last_fetch = Time.now
end

Given /^several locations were assigned to me before that retrieval$/ do
  fake_time = @locationHelper.remember_last_fetch('that retrieval') - rand(1..10).days
  params = {
    created_at: fake_time,
    updated_at: fake_time
  }
  
  SEVERAL_LOCATION_AMOUNT.times do
    new_location = FactoryGirl.build :location, params
    new_location.users << @authHelper.remember_logged_in_user
    new_location.save
  end
end

Given /^a changed set of locations was assigned to me after that retrieval$/ do
  fake_time = @locationHelper.remember_last_fetch('that retrieval') + rand(1..10).days
  
  # update one of the existing ones if there is one:
  old_location = Location.last
  unless old_location.nil?
    old_location.update_attributes(name: 'Test', updated_at: fake_time)
    old_location.should_not be_nil
    @locationHelper.modified_locations << old_location
  end
    
  # add some more
  params = {
    created_at: fake_time,
    updated_at: fake_time
  }
  SEVERAL_LOCATION_AMOUNT.times do
    new_location = FactoryGirl.build :location, params
    new_location.users << @authHelper.remember_logged_in_user
    new_location.save
    @locationHelper.modified_locations << new_location
  end
end

Then /^I should have received a valid location list/ do
  result = JSON.parse(@jsonHelper.last_response.body)
  
  result.should have_key('locations')
  result['locations'].should be_a_kind_of(Array)  
  result['locations'].each do |location_hash|
    TestHelper.verify_obj_integrity location_hash, 'location'
    location_hash.should have_key('deleted_at')
    location_hash['deleted_at'].should be_nil
  end
  
  result.should have_key('deleted_locations')
  result['deleted_locations'].should be_a_kind_of(Array)
  result['deleted_locations'].each do |location_hash|
    TestHelper.verify_obj_integrity location_hash, 'location'
    location_hash.should have_key('deleted_at')
    location_hash['deleted_at'].should_not be_nil
  end
  
  @locationHelper.locations_list = {locations: result['locations'], deleted_locations: result['deleted_locations']}
end

Then /^(.+) should( not| no longer)? be in the location list(?: marked as (deleted|existing))?$/ do |location_str, negation_str, marked_as_str|  
  the_locations_arr = case location_str
  when 'the previously deleted location'
    [ @locationHelper.remember_location('previously deleted location') ]
  when 'the same locations as assigned before'
    @locationHelper.remember_locations('same locations as assigned before')
  when 'the same locations as assigned after the retrieval'
    @locationHelper.remember_modified_locations('the same locations as assigned after the retrieval')
  when 'the location with its new data'
    @locationHelper.locations_submitted.should_not be_nil
    @locationHelper.locations_submitted.should have_at_least(1).items
    @locationHelper.locations_submitted.map { |params| FactoryGirl.build(:location,params[:location]) }
  when 'the location with its old data'
    old_location = @locationHelper.remember_location('the location with its old data')
    old_location.id = nil # we don't count the id as 'data'
    [ old_location ]
  else
    raise Cucumber::Undefined.new("No such location(s): '#{location_str}'")
  end
  
  @locationHelper.ensure_in_list('the location list', the_locations_arr, !negation_str.nil?, marked_as_str)  
end

Then /^the location list should be empty$/ do
  locations_list = @locationHelper.remember_locations_list('the location list')
  locations_list[:locations].should be_empty
end
