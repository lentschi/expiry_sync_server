Feature: Product entry updating

Background:
    Given a valid user exists
    	And I am logged in with that user

Scenario: Updating a product with new entry data, but unchanged article
	Given a location created by me is assigned to me
		And there is a product entry assigned to me at that location
	When I try to update that product entry with valid data, not changing the article
	Then the call should be successful
		And I should have received a valid product entry
		And I should have received a valid article wrapped in its product entry
		And that article should be the same as the one attached to the initial product entry
    	And that article should have set its data as requested

Scenario: Updating a product with new entry data, changing the article's data
	Given a location created by me is assigned to me
		And there is a product entry assigned to me at that location
	When I try to update that product entry with valid data, changing the article's data
	Then the call should be successful
		And I should have received a valid product entry
		And I should have received a valid article wrapped in its product entry
		And that article should be the same as the one attached to the initial product entry
    	And that article should have set its data as requested

Scenario: Updating a product with new entry data, swapping the article for a different one, that is new to the server
	Given a location created by me is assigned to me
		And there is a product entry assigned to me at that location
	When I try to update that product entry with valid data, changing the article for a new article
	Then the call should be successful
		And I should have received a valid product entry
		And I should have received a valid article wrapped in its product entry
		And that article should not have existed before
    	And that article should have set its data as requested

Scenario: Updating a product with new entry data, changing the article for a different one, that already exists on the server
	Given a valid article exists in the db
		And a location created by me is assigned to me
		And there is a product entry assigned to me at that location
	When I try to update that product entry with valid data, changing the article's barcode for that of the previously mentioned article
	Then the call should be successful
		And I should have received a valid product entry
		And I should have received a valid article wrapped in its product entry
		And that article should be the same as the one existing without an entry in the beginning
    	And that article should have set its data as requested
    	
Scenario: Updating a product entry, which hasn't been created by the current user, with new entry data
	Given a location created by someone else is assigned to me
		And there is a product entry assigned to someone else at that location
	When I try to update that product entry with valid data, not changing the article
	Then the call should be successful
		And I should have received a valid product entry
		And I should have received a valid article wrapped in its product entry
		And that article should be the same as the one attached to the initial product entry
    	And that article should have set its data as requested
    	