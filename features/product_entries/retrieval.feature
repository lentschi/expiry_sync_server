Feature: Product entry retrieval
	The user should be able to fetch product entries from their own locations or locations,
	that are shared with them.
	
Background:
    Given a valid user exists
    	And I am logged in with that user

    	
Scenario: Retrieve all product entries assigned to a location
	Given a location is assigned to me
	When I request a list of product entries for that location
	Then the call should be successful
		And I should have received a valid list of product entries
		
Scenario: Retrieve list of all product entries for a location, 
	which is still empty (directly after creating the location)
    Given I just created a new location
    When I request a list of product entries for that location
    Then the call should be successful
        And I should have received a valid list of product entries
        And the product entry list should be empty
        
Scenario: Retrieve list of all product entries for a location, 
	which is still empty (directly after creating the location)
    Given a location is assigned to me
    	And there are several product entries assigned to me at that location
    When I request a list of product entries for that location
    Then the call should be successful
        And I should have received a valid list of product entries
        And the same product entries as assigned before should be in the product entry list

Scenario: Retrieve list of product entries for a location, 
	that were changed
	Given a location is assigned to me
		And the client had performed a product entry retrieval for that location earlier
		And several product entries were assigned to that location before that retrieval
		And a changed set of product entries was assigned to me after that retrieval
	When I request a list of product entries for that location specifying the time of that retrieval
    Then the call should be successful
    	And I should have received a valid product entry list
        And the same product entries as assigned after the retrieval should be in the product entry list

Scenario: Retrieve list of product entries for a location, 
	that were changed
	Given a location is assigned to me
		And the client had performed a product entry retrieval for that location earlier
		And several product entries were assigned to that location before that retrieval
		And a changed set of product entries (where some have even been deleted) was assigned to me after that retrieval
	When I request a list of product entries for that location specifying the time of that retrieval
    Then the call should be successful
    	And I should have received a valid product entry list
        And the same product entries as assigned after the retrieval should be in the product entry list
        And that list should contain the product entries that were deleted after the retrieval with respective deleted timestamps