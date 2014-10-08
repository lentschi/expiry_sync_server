Feature: Article retrieval
	Any user should be able to retrieve details about an article, if
	it exists in the server db or can be retrieved through a remote connection like Barcoo

Background:
    Given a valid user exists
    	And I am logged in with that user

Scenario: Fetch an existing article from db
	Given a valid article exists in the db
	When I try to fetch the article details using the barcode
	Then I should receive the details of that article
	
Scenario: Fetch an article from barcoo
	Given a valid article exists in the barcoo db
	When I try to fetch that article
	Then the call should be successful
		And I should have received a valid article
		And the received article should be the same as the one in the barcoo db