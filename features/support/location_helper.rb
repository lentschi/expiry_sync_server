module CucumberLocationHelpers
  class LocationHelper
    include RSpec::Matchers
    
    cattr_accessor :valid_location_data_arr
    
    attr_accessor :valid_location_data_counter, 
       :locations, :modified_locations, :locations_list, :locations_submitted,
       :last_fetch
    
    def initialize()
      @valid_location_data_counter = 0
      @locations = Array.new
      @modified_locations = Array.new
      @locations_list = Array.new
    end
    
    def get_valid_location_data()
      location_data = @@valid_location_data_arr[@valid_location_data_counter]
      @valid_location_data_counter += 1
      @valid_location_data_counter = 0 if @valid_location_data_counter >= @@valid_location_data_arr.length
      
      location_data.deep_dup
    end
    
    def remember_location(reference)    
      locations = remember_locations(reference)
      
      locations.should have(1).items, TestHelper.reference_error_str(reference)
      locations[0]
    end
    
    def remember_locations(reference)
      @locations.should_not be_nil, TestHelper.reference_error_str(reference)
      @locations
    end
    
    def remember_modified_locations(reference)
      @modified_locations.should_not be_nil, TestHelper.reference_error_str(reference)
      @modified_locations
    end
  
    def remember_locations_list(reference)
      @locations_list.should_not be_nil, TestHelper.reference_error_str(reference)
      @locations_list
    end
    
    def remember_last_fetch(reference)
      @last_fetch.should_not be_nil, TestHelper.reference_error_str(reference)
      @last_fetch
    end
    
    def ensure_in_list(reference, the_locations_arr, negated, marked_as_str)
      if negated and !marked_as_str.nil?
        raise Cucumber::Undefined.new("Cannot ensure that a location that is not supposed to be there should be marked as '#{marked_as_str}'")
      end 
      
      locations_list = remember_locations_list(reference)
      
      the_locations_arr.each do |the_location|
          found = nil
          (locations_list[:locations] + locations_list[:deleted_locations]).each do |location_hash|
            # only compare the id if we have one (when comparing 'data' we won't have one):
            if (the_location.id.nil? || Integer(location_hash['id']) == the_location.id) \
              and location_hash['name'] == the_location.name
              found = location_hash 
              break
            end
          end
          
          unless negated
            found.should_not be_nil, "Required location (Name: '#{the_location['name']}') not found in list"
            
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
  end
end

World(CucumberLocationHelpers)