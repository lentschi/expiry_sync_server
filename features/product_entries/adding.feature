Feature: Product entry handling
    The user should be able to create new product entries for a location, 
    update existing ones, and remove those products that have been consumed or thrown away.
    
Background:
    Given a valid user exists
    	And I am logged in with that user
   	Given a location created by me is assigned to me


Scenario: Add a product entry with valid data
    When I try to add a product entry with valid data containing data for an article, that is new to the server
    Then the call should be successful
        And I should have received a valid product entry
        	And I should have received a valid article wrapped in its product entry
        	And that article should not have existed before
        	And that article should have set its data as requested
        	
Scenario: Add a product entry with valid data and an article that has been added before
	Given there is an article created by me
	When I try to add a product entry with valid data containing article data which is the same as that article's data
	Then the call should be successful
        And I should have received a valid product entry
        	And I should have received a valid article wrapped in its product entry
        	And that article should be the same as the one existing in the beginning
        	And that article should have set its data as requested
        	
Scenario: Add a product entry with valid data and an article that has been added by me before, but shall now been changed 
	Given there is an article created by me
	When I try to add a product entry with valid data containing the same article barcode but different additional article data 
	Then the call should be successful
        And I should have received a valid product entry
        	And I should have received a valid article wrapped in its product entry
        	And that article should be the same as the one existing in the beginning
        	And that article should have set its data as requested
        	
Scenario: Add a product entry with valid data and an article that has been added by someone else before, but shall now been changed 
	Given there is an article created by someone else
	When I try to add a product entry with valid data containing the same article barcode but different additional article data 
	Then the call should be successful
        And I should have received a valid product entry
        	And I should have received a valid article wrapped in its product entry
        	And that article should not have existed before
        	And that article should have set its data as requested