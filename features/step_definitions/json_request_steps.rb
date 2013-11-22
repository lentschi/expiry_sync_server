require 'debugger'
require "addressable/uri"

@routingError = nil

def set_json_request_header!
  header 'Accept', "application/json"
  header 'Content-Type', "application/json"
end

def json_request(path, request_opts)
  set_json_request_header!
  begin 
    request path, request_opts
    @requestError = nil
  rescue Exception => requestError
    @requestError = requestError
  end
end

def json_get(path, params=nil)
  request_opts = {
    method: 'GET'
  }
    
  unless params.nil? or params.empty?
    uri = Addressable::URI.new()
    uri.query_values = params
    path = "#{path}?#{uri.query}"
  end 
  
  json_request path, request_opts
end

def json_post(path, params)
  request_opts = {
    method: 'POST',
    input: params.to_json
  }
  
  json_request path, request_opts
end

def json_put(path, params)
  request_opts = {
    method: 'PUT',
    input: params.to_json
  }
  
  json_request path, request_opts
end

def json_delete(path)
  request_opts = {
    method: 'DELETE'
  }
  
  json_request path, request_opts
end

Then /^the call should (be successful|fail)$/ do |expected_outcome|
  unless expected_outcome == 'fail' and !@requestError.nil?
    raise @requestError unless @requestError.nil?
    
    begin
      result = JSON.parse(last_response.body)
    rescue JSON::ParserError => jsonError
      raise JSON::ParserError.new("Could not parse the following as json (#{jsonError.message}): '#{last_response.body}'")
    end
    
    if expected_outcome == 'be successful'
      result["status"].should eq('success'), "Unsuccessful API call - result:\n" + result.to_yaml.to_s
    else
      result["status"].should_not eq('success'), "Unexpected successful API call - result:\n" + result.to_yaml.to_s
    end
  end
end