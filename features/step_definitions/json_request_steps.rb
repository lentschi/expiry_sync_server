require 'debugger'
require "addressable/uri"

Before do |scenario|
  @jsonHelper = CucumberJsonHelpers::JsonHelper.new
end

Then /^the call should (be successful|fail)$/ do |expected_outcome|
  unless expected_outcome == 'fail' and !@jsonHelper.requestError.nil?
    raise @jsonHelper.requestError unless @jsonHelper.requestError.nil?
    
    begin
      result = JSON.parse(@jsonHelper.last_response.body)
    rescue JSON::ParserError => jsonError
      raise JSON::ParserError.new("Could not parse the following as json (#{jsonError.message}): '#{@jsonHelper.last_response.body}'")
    end
    
    if expected_outcome == 'be successful'
      result["status"].should eq('success'), "Unsuccessful API call - result:\n" + result.to_yaml.to_s
    else
      result["status"].should_not eq('success'), "Unexpected successful API call - result:\n" + result.to_yaml.to_s
    end
  end
end

Then /^I should have received errors on the (.+) field$/ do |field_name|
  result = JSON.parse(@jsonHelper.last_response.body)
  result.should have_key("errors")
  result["errors"].should have_key(field_name)
  result["errors"][field_name].should be_kind_of(Array)
  result["errors"][field_name].should have_at_least(1).items
end