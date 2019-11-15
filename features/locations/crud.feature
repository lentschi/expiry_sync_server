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

# DELETING
Scenario: Delete an existing location assigned created by the current user
    Given a location created by me is assigned to me
    When I try to delete that location
    Then the call should be successful
    When I request a list of my locations
    Then the call should be successful
        And I should have received a valid location list
    When I request a list of product entries for that location
        Then the call should fail

Scenario: Delete an existing location, that is not assigned to the current user
    Given a location is not assigned to me
    When I try to delete that location
    Then the call should fail

Scenario: Delete an existing location for a user other than the current user
    Given a location created by someone else is assigned to me
    When I try to delete that location for the other user
    Then the call should fail

# UPDATING
Scenario: Update the data of an existing location assigned to the current user
    Given a location created by me is assigned to me
    When I try to update that location with different valid data
    Then the call should be successful
    When I request a list of my locations
    Then the call should be successful
        And I should have received a valid location list
        And the location with its new data should be in the location list
        And the location with its old data should no longer be in the location list
