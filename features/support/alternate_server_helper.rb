module CucumberAlternateServerHelpers
  class AlternateServerHelper
    include RSpec::Matchers
    
    SEVERAL_AMOUNT = 3
    
    attr_accessor :new_alternate_server, :existing_servers
    
    def new_alternate_server
      @new_alternate_server ||= FactoryGirl.build(:alternate_server)
    end
    
    def existing_servers
      return @existing_servers unless @existing_servers.nil?
      @existing_servers = []
      SEVERAL_AMOUNT.times do 
        @existing_servers << FactoryGirl.create(:alternate_server)
      end
    end
    
    def remember_new_alternate_server(reference)
      @new_alternate_server.should_not be_nil, TestHelper.reference_error_str(reference)
      @new_alternate_server
    end
    
    def remember_existing_servers(reference)
      @existing_servers.should_not be_nil, TestHelper.reference_error_str(reference)
      @existing_servers
    end
  end
end

World(CucumberAlternateServerHelpers)