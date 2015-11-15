Feature: Product entry adding
    The user should be able to create new product entries for a location.
    The referenced articles should be created/reused automatically.
    
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
    	
Scenario: Add a product entry without a barcode
    When I try to add a product entry without an article barcode containing data for an article, that is new to the server
    Then the call should be successful
        And I should have received a valid product entry
    	And I should have received a valid article wrapped in its product entry
    	And that article should not have existed before
    	And that article should have set its data as requested
        	
Scenario: Add a product entry with valid data and an article that has been added before and shall not be changed now
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

Scenario: Add a product entry with valid data and an article that has been added by someone else before and shall not be changed now
	Given there is an article created by someone else
	When I try to add a product entry with valid data containing article data which is the same as that article's data
	Then the call should be successful
        And I should have received a valid product entry
    	And I should have received a valid article wrapped in its product entry
    	And that article should be the same as the one existing in the beginning
    	And that article should have set its data as requested        	

Scenario: Add a product entry with valid data and an article that has been added by someone else before and shall now been changed 
	Given there is an article created by someone else
	When I try to add a product entry with valid data containing the same article barcode but different additional article data 
	Then the call should be successful
        And I should have received a valid product entry
    	And I should have received a valid article wrapped in its product entry
    	And that article should not have existed before
    	And that article should have set its data as requested

Scenario Outline: Trying to add a product entry with invalid data
	When I try to add a product entry <with_what_data?> containing data for an article, that is new to the server
	Then the call should fail
Examples:
	| with_what_data? |
	| without specifying an amount |
	| without an article name |	