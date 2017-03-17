Feature: Article retrieval
	Any user should be able to retrieve details about an article, if
	it exists in the server db or can be retrieved through a remote connection

Background:
    Given a valid user exists
    	And I am logged in with that user

Scenario: Fetch an existing article from db
	Given a valid article exists in the db
	When I try to fetch that article
	Then the call should be successful
		And I should have received a valid article
		And the received article should be the same as the one in the db
	
Scenario: Fetch an article from the testing remote
	Given a valid article exists in the remote testing db
	When I try to fetch that article
	Then the call should be successful
		And I should have received a valid article
		And the received article should be the same as the one in the remote testing db