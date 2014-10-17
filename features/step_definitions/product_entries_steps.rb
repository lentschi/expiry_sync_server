ADD_PATH = '/product_entries'
DELETE_PATH = '/product_entries'
UPDATE_PATH = '/product_entries'

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

VALID_ARTICLE_DATA = [
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
CucumberProductEntryHelpers::ProductEntryHelper.valid_article_data_arr = VALID_ARTICLE_DATA

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



When /^I try to add a product entry with valid data containing (.+)$/ do |containing_str|
	params = Hash.new
	params[:product_entry] = @productEntryHelper.get_valid_entry_data()
	
	existing_location = Location.find_by(creator_id: @authHelper.logged_in_user.id)
	existing_location.should_not be_nil, "There's no such thing as 'valid data' for an entry as long as there's no location"
	params[:product_entry][:location_id] = existing_location.id
	
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
	
	@jsonHelper.json_post ADD_PATH, params
  @productEntryHelper.entries_submitted << params
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



Then /^that article should (not have existed before|be the same as the one existing in the beginning)$/ do |should_str|
	articles = @productEntryHelper.remember_articles('that article')
	articles.length.should be > 0, TestHelper.reference_error_str('that article')
	
	article_before = (articles.length > 1) ? articles[0] : nil
	that_article = articles.last
	
	if should_str == "not have existed before"
		@previously_existing_article_ids.should_not include(that_article.id), "article HAS existed before"
	elsif should_str == "be the same as the one existing in the beginning"
		article_before.should_not be_nil, "article HAS NOT existed before"
		article_before.id.should be == that_article.id, "That is not the same article as in the beginning (ID #{article_before.id} <> #{that_article.id})."
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