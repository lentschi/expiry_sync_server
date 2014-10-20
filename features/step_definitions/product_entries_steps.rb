ADD_PRODUCT_ENTRY_PATH = '/product_entries'
DELETE_PRODUCT_ENTRY_PATH = '/product_entries'
UPDATE_PRODUCT_ENTRY_PATH = '/product_entries'

VALID_ENTRY_DATA = [
	{ 
		amount: 1, 
		expiration_date: "17-10-2015",
		description: "sehr sehr gut"
	},
	{ 
		amount: 2, 
		expiration_date: "17-10-2016",
		description: "sehr gut"
	}
]

VALID_ENTRY_ARTICLE_DATA = [
	{
		name: "Meßmer Pfefferminze",
		barcode: "4001257153002"
	},
	{
		name: "Eza  Bio Mascao Schokolade",
		barcode: "9004593973889"
	}
]

CucumberProductEntryHelpers::ProductEntryHelper.valid_entry_data_arr = VALID_ENTRY_DATA
CucumberProductEntryHelpers::ProductEntryHelper.valid_article_data_arr = VALID_ENTRY_ARTICLE_DATA

Before do |scenario|
  @productEntryHelper = CucumberProductEntryHelpers::ProductEntryHelper.new
  @previously_existing_article_ids = Article.pluck(:id)
end


Given /^there is an article created by (.+)$/ do |creator_str|
	created_by_me = case creator_str
  when 'me'
    true
  when 'someone else'
    false
  else
    raise Cucumber::Undefined.new("No such creator: '#{creator_str}'")
  end
  
  @authHelper.other_user.make_current unless created_by_me
  existing_article = FactoryGirl.create(:article, @productEntryHelper.get_valid_article_data())
  @productEntryHelper.articles << existing_article
  @previously_existing_article_ids << existing_article.id
end



Given /^there is a product entry assigned to me at that location$/ do
	that_location = @locationHelper.remember_location('that location')
	entry = FactoryGirl.create(:product_entry, location: that_location)
	@productEntryHelper.entries << entry
end



When /^I try to add a product entry (.+) containing (.+)$/ do |with_data_str, containing_str|
	params = Hash.new
	params[:product_entry] = @productEntryHelper.get_valid_entry_data()
	
	# get a location belonging to the current user:
	existing_location = Location.find_by(creator_id: @authHelper.logged_in_user.id)
	existing_location.should_not be_nil, "There's no such thing as 'valid data' for an entry as long as there's no location"
	params[:product_entry][:location_id] = existing_location.id
	
	# where to get the data for the article from:
	params[:product_entry][:article] = case containing_str
	when "data for an article, that is new to the server"
		@productEntryHelper.get_valid_article_data()
	when "article data which is the same as that article's data"
		that_article = @productEntryHelper.remember_article('that article')
		{
			barcode: that_article.barcode,
			name: that_article.name
		}
	when "the same article barcode but different additional article data"
		that_article = @productEntryHelper.remember_article('that article')
		other_data = @productEntryHelper.get_valid_article_data()
		{
			barcode: that_article.barcode,
			name: other_data[:name]
		}
	else
		raise Cucumber::Undefined.new("Don't know what containing that means: '#{containing_str}'")
	end
	
	# valid or invalid data:
	case with_data_str 
	when 'without specifying an amount'
		params[:product_entry].delete(:amount)
	when 'without an article barcode'
		params[:product_entry][:article].delete(:barcode)
	else 
		raise Cucumber::Undefined.new("Don't know what that means: '#{with_data_str}'") unless with_data_str == 'with valid data'
	end
	
	@jsonHelper.json_post ADD_PRODUCT_ENTRY_PATH, params
  @productEntryHelper.entries_submitted << params
end 


When /^I try to update that product entry with valid data, (.+)$/ do |data_specs_str|
	entry = @productEntryHelper.remember_entry('that product entry')
	
	params = Hash.new
	params[:product_entry] = @productEntryHelper.get_valid_entry_data()
	params[:product_entry][:article] = {barcode: entry.article.barcode, name: entry.article.name}
	
	case data_specs_str
	when "not changing the article"
	when "changing the article's data"
		another_article = @productEntryHelper.get_valid_article_data()
		params[:product_entry][:article][:name] = another_article[:name]
	when "changing the article for a new article" 
		params[:product_entry][:article] = @productEntryHelper.get_valid_article_data()
	when "changing the article's barcode for that of the previously mentioned article"
		original_article = @articleHelper.remember_existing_article("What do you mean by 'previously mentioned article'")
		params[:product_entry][:article][:barcode] = original_article.barcode
	else
		raise Cucumber::Undefined.new("Don't know what that means: '#{data_specs_str}'")
	end
	
	@jsonHelper.json_put UPDATE_PRODUCT_ENTRY_PATH + "/" + entry.id.to_s, params
  @productEntryHelper.entries_submitted << params
end


When /^I try to remove that product entry$/ do
	that_entry = @productEntryHelper.remember_entry('that product entry')
	@jsonHelper.json_delete DELETE_PRODUCT_ENTRY_PATH + '/' + that_entry.id.to_s
end


Then /^I should have received a valid product entry$/ do
	result = JSON.parse(@jsonHelper.last_response.body)
  
  TestHelper.verify_contained_obj_integrity result, "product_entry"
  result["product_entry"].should have_key "id"
  result["product_entry"].should have_key "description"
  result["product_entry"].should have_key "creator_id"
  
  received_entry = FactoryGirl.build(:product_entry, result["product_entry"])
  @productEntryHelper.entries = [ received_entry ]
end



Then /^I should have received a valid article wrapped in its product entry$/ do
	result = JSON.parse(@jsonHelper.last_response.body)
  
  TestHelper.verify_contained_obj_integrity result, "product_entry"
  TestHelper.verify_contained_obj_integrity result["product_entry"], "article"
  result["product_entry"]["article"].should have_key "id"
  result["product_entry"]["article"].should have_key "barcode"
  result["product_entry"]["article"].should have_key "name"

	received_article = FactoryGirl.build(:article, result["product_entry"]["article"])
  @productEntryHelper.articles << received_article
end



Then /^that article should (not have existed before|be the same as the one existing in the beginning|be the same as the one attached to the initial product entry|be the same as the one existing without an entry in the beginning)$/ do |should_str|
	articles = @productEntryHelper.remember_articles('that article')
	articles.length.should be > 0, TestHelper.reference_error_str('that article')
	
	article_before = (articles.length > 1) ? articles[0] : nil
	that_article = articles.last
	
	case should_str
	when "not have existed before"
		@previously_existing_article_ids.should_not include(that_article.id), "article HAS existed before"
		unless article_before.nil?
			article_before.id.should_not be == that_article.id
		end
	when "be the same as the one existing in the beginning"
		article_before.should_not be_nil, "article HAS NOT existed before"
		article_before.id.should be == that_article.id, "That is not the same article as in the beginning (ID #{article_before.id} <> #{that_article.id})."
	when "be the same as the one attached to the initial product entry"
		entry_before = @productEntryHelper.remember_entry('initial product entry')
		article_before = entry_before.article
		article_before.id.should be == that_article.id, "That is not the same article as the one attached to the initial product entry (ID #{article_before.id} <> #{that_article.id})."
	when "be the same as the one existing without an entry in the beginning"
		article_before = @articleHelper.remember_existing_article("What do you mean by 'the one existing without an entry in the beginning'")
		article_before.id.should be == that_article.id, "That is not the same article as the one without an entry in the beginning (ID #{article_before.id} <> #{that_article.id})."
	else
		raise Cucumber::Undefined.new("Don't understand how it should be: '#{should_str}'")
	end
end 



Then /^that article should have set its data as requested$/ do
	articles = @productEntryHelper.remember_articles('that article')
	articles.length.should be > 0, TestHelper.reference_error_str('that article')
	that_article = articles.last
	
	@productEntryHelper.entries_submitted.length.should be > 0, TestHelper.reference_error_str('as requested')
	requested_article = @productEntryHelper.entries_submitted.last[:product_entry][:article]

	requested_article[:barcode].should be == that_article.barcode
	requested_article[:name].should be == that_article.name
end