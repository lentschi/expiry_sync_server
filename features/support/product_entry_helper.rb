module CucumberProductEntryHelpers
  class ProductEntryHelper
    include RSpec::Matchers
    
    attr_accessor :entries, :entries_submitted, :articles, 
      :valid_entry_data_counter, :valid_article_data_counter,
      :product_entries_list
      
    cattr_accessor :valid_entry_data_arr, :valid_article_data_arr
    
    def initialize()
    	@valid_entry_data_counter = 0
    	@valid_article_data_counter = 0
      @entries = Array.new
      @entries_submitted = Array.new
      @articles = Array.new
    end
    
    def get_valid_entry_data()
      entry_data = @@valid_entry_data_arr[@valid_entry_data_counter]
      @valid_entry_data_counter += 1
      @valid_entry_data_counter = 0 if @valid_entry_data_counter >= @@valid_entry_data_arr.length
      
      entry_data.deep_dup
    end
    
    def get_valid_article_data()
      article_data = @@valid_article_data_arr[@valid_article_data_counter]
      @valid_article_data_counter += 1
      @valid_article_data_counter = 0 if @valid_article_data_counter >= @@valid_article_data_arr.length
      
      article_data.deep_dup
    end
    
    def remember_entry(reference)
    	entries = remember_entries(reference)
      
      entries.should have(1).items, TestHelper.reference_error_str(reference)
      entries[0]
    end
    
    def remember_entries(reference)
			@entries.should_not be_nil, TestHelper.reference_error_str(reference)
      @entries
    end
    
    def remember_entries_list(reference)
       @product_entries_list.should_not be_nil, TestHelper.reference_error_str(reference)
       @product_entries_list
     end
    
    def remember_article(reference)
    	articles = remember_articles(reference)
      
      articles.should have(1).items, TestHelper.reference_error_str(reference)
      articles[0]
    end
        
    def remember_articles(reference)
			@articles.should_not be_nil, TestHelper.reference_error_str(reference)
      @articles
    end
  end
end

World(CucumberProductEntryHelpers)