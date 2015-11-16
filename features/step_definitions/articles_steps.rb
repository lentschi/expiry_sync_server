RETRIEVE_ARTICLE_PATH = "/articles/by_barcode"

Before do |scenario|
  @articleHelper = CucumberArticleHelpers::ArticleHelper.new
end

Given /^a valid article exists in the db$/ do
	@articleHelper.existing_article = FactoryGirl.create(:article)
end

Given /^a valid article exists in the barcoo db$/ do
	# Note: we cannot influence that in any way
	@articleHelper.existing_article = Article.new
	@articleHelper.existing_article.barcode = 9009700300206 
	@articleHelper.existing_article.name = 'Vöslauer ohne'
end

When /^I try to fetch that article$/ do
	article = @articleHelper.remember_existing_article
	@jsonHelper.json_get RETRIEVE_ARTICLE_PATH + '/' + article.barcode.to_s
	result = JSON.parse(@jsonHelper.last_response.body)
end

Then /^I should have received a valid article$/ do
	result = JSON.parse(@jsonHelper.last_response.body)
	result.should have_key('article')
	result['article'].should be_a_kind_of(Hash)
	result['article'].should have_key('name')
	
	@articleHelper.received_article = result['article']
end

Then /^the received article should be the same as the one in the( barcoo)? db$/ do |ingored|
	existingArticle = @articleHelper.remember_existing_article
	receivedArticle = @articleHelper.remember_received_article
	
  existingArticle.name.should == receivedArticle['name']
end