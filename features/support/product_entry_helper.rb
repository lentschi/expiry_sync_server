module CucumberProductEntryHelpers
  class ProductEntryHelper
    include RSpec::Matchers
    
    attr_accessor :entries, :entries_submitted, :articles, 
      :valid_entry_data_counter, :valid_article_data_counter,
      :product_entries_list, :last_fetch, :modified_entries
      
    cattr_accessor :valid_entry_data_arr, :valid_article_data_arr
    
    def initialize()
    	@valid_entry_data_counter = 0
    	@valid_article_data_counter = 0
      @entries = Array.new
      @entries_submitted = Array.new
      @articles = Array.new
      @last_fetch = Hash.new
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
    
    def remember_modified_entries(reference)
      @modified_entries.should_not be_nil, TestHelper.reference_error_str(reference)
      @modified_entries
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
    
    def remember_last_fetch(location, reference)
      @last_fetch[location.id].should_not be_nil, TestHelper.reference_error_str(reference)
      @last_fetch[location.id]
    end
    
    def ensure_in_list(reference, the_entries_arr, negated, marked_as_str)
      if negated and !marked_as_str.nil?
        raise Cucumber::Undefined.new("Cannot ensure that a product entry that is not supposed to be there should be marked as '#{marked_as_str}'")
      end 
      
      entries_list = remember_entries_list(reference)
      
      the_entries_arr.each do |the_entry|
          found = nil
          (entries_list[:entries] + entries_list[:deleted_entries]).each do |entry_hash|
            # only compare the id if we have one (when comparing 'data' we won't have one):
            if (the_entry.id.nil? || Integer(entry_hash['id']) == the_entry.id) \
              and entry_hash['amount'] == the_entry.amount \
              and entry_hash['description'] == the_entry.description \
              and entry_hash['expiration_date'] == the_entry.expiration_date \
              and entry_hash['article']['barcode'] == the_entry.article.barcode
              found = entry_hash 
              break
            end
          end
          
          unless negated
            found.should_not be_nil, "Required product entry (Barcode: '#{the_entry['article']['barcode']}, Amount: '#{the_entry['amount']}, Description: '#{the_entry['description']}, Expiration date: '#{the_entry['expiration_date']}) not found in list"
            
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

World(CucumberProductEntryHelpers)