Feature: Product entry deletion
	The user should be able to remove product entries from their own locations or locations,
	that are shared with them.
	
Background:
    Given a valid user exists
    	And I am logged in with that user

Scenario: Remove a product entry from a location that belongs to me
	Given a location created by me is assigned to me
		And there is a product entry assigned to me at that location
	When I try to remove that product entry
	Then the call should be successful
	
Scenario: Remove a product entry from a location that belongs to me
	Given a location created by someone else is assigned to me
		And there is a product entry assigned to me at that location
	When I try to remove that product entry
	Then the call should be successful

Scenario: Remove a product entry from a location that does not belong to me
	Given a location created by someone else is not assigned to me
		And there is a product entry assigned to me at that location
	When I try to remove that product entry
	Then the call should fail