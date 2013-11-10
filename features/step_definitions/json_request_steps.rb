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

Then /^the call should (be successful|fail)$/ do |expected_outcome|
  result = JSON.parse(last_response.body)
  if expected_outcome == 'be successful'
    result["status"].should eq('success'), "Unsuccessful API call - result:\n" + result.to_yaml.to_s
  else
    result["status"].should_not eq('success'), "Unexpected successful API call - result:\n" + result.to_yaml.to_s
  end
end