Feature: Location handling
    The user should be able to create new locations, 
    update existing ones, and delete those that are no longer required.
    
Background:
    Given a valid user exists
    Given I am logged in with that user

# ADDING        
Scenario: Add a location with valid data
    When I try to add a location with valid data
    Then the call should be successful
        And I should have received a valid location
        
# DELETING
Scenario: Delete an existing location assigned to the current user
    Given a location is assigned to me
    When I try to delete that location 
    Then the call should be successful
    When I request a list of my locations
    Then the call should be successful
        And I should have received a valid location list
        But the previously deleted location should not be in that list

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