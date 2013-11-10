Feature: Location handling
	The user should be able to retrieve their locations, create new ones, 
	update existing ones, and delete those that are no longer required
	
Background:
	Given a valid user exists
	Given I am logged in with that user
	
Scenario: Retrieve locations assigned to the current user
	When I request a list of my locations
	Then the call should be successful
		And I should have received a valid location list
		
Scenario: Retrieve list of locations assigned to the current user, which is still empty (directly after registration)
	Given I successfully register a new user
		And I am logged in with that user
	When I request a list of my locations
	Then the call should be successful
		And I should have received a valid location list
		And that list should be empty
		
Scenario: Retrieve list of locations assigned to the current user, which contains some locations
	Given several locations are assigned to me
	When I request a list of my locations
	Then the call should be successful
		And I should have received a valid location list
		And that list should contain the same locations as assigned before
		
Scenario: Add a default location
	When I try to add a location with a auto-generated uuid as its name
	Then the call should be successful
		And I should have received a valid location

Scenario: Add a location with a custom location
	When I try to add a location with a custom name
	Then the call should be successful
		And I should have received a valid location
		
Scenario: Add a location with a password protected custom location
	When I try to add a location with a custom name and password
	Then the call should be successful
		And I should have received a valid location
	