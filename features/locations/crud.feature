Feature: Location handling
    The user should be able to create new locations, 
    update existing ones, and delete those that are no longer required.
    
Background:
    Given a valid user exists
    	And I am logged in with that user

# ADDING        
Scenario: Add a location with valid data
    When I try to add a location with valid data
    Then the call should be successful
        And I should have received a valid location

Scenario: Add two locations with the same name
    When I try to add a location with valid data
    Then the call should be successful
        And I should have received a valid location
    When I try to add a location with valid data using the same location name as before
    Then the call should fail
        
# DELETING
Scenario: Delete an existing location assigned created by the current user
    Given a location created by me is assigned to me
    When I try to delete that location 
    Then the call should be successful
    When I request a list of my locations
    Then the call should be successful
        And I should have received a valid location list
        And the previously deleted location should be in the list marked as deleted

Scenario: Delete an existing location, that is not assigned to the current user
    Given a location is not assigned to me
    When I try to delete that location
    Then the call should fail
        
Scenario: Delete an existing location, that is assigned to the current user 
    but was created by someone else than the current user
    Given a location created by someone else is assigned to me
    When I try to delete that location
    Then the call should fail

# UPDATING
Scenario: Update the data of an existing location assigned to the current user
    Given a location is assigned to me
    When I try to update that location 
    Then the call should be successful
    When I request a list of my locations
    Then the call should be successful
        And I should have received a valid location list
        And the previously updated location should appear with the new data
        And the previously updated location should no longer appear with its old data