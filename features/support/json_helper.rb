module CucumberJsonHelpers
  class JsonHelper < ActionDispatch::IntegrationTest
    include Rack::Test::Methods
    
    attr_accessor :requestError
    
    def initialize
      @requestError = nil
    end
    
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
  end
end

World(CucumberJsonHelpers)