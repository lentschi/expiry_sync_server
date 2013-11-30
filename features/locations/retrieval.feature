Feature: Location retrieval
    The user should be able to list their locations.
    
Background:
    Given a valid user exists
    	And I am logged in with that user


# 'all locations' are only requested, if there has never been a retrieval  
Scenario: Retrieve all locations assigned to the current user
    When I request a list of my locations
    Then the call should be successful
        And I should have received a valid location list
        
Scenario: Retrieve list of all locations assigned to the current user, 
	which is still empty (directly after registration)
    Given I just registered a new user
        And I am logged in with that user
    When I request a list of my locations
    Then the call should be successful
        And I should have received a valid location list
        And the location list should be empty

# Login on a new device / different user who's been newly assigned to the location:        
Scenario: Retrieve list of all locations assigned to the current user, 
    which contains some locations
    Given several locations are assigned to me
    When I request a list of my locations
    Then the call should be successful
        And I should have received a valid location list
        And the same locations as assigned before should be in the location list

Scenario: Retrieve list of locations assigned to the current user, 
	that was changed
	Given the client had performed a location retrieval earlier
		And several locations were assigned to me before that retrieval
		And a changed set of locations was assigned to me after that retrieval
	When I request a list of my locations specifying the time of that retrieval
    Then the call should be successful
    	And I should have received a valid location list
        And the same locations as assigned after the retrieval should be in the location list

Scenario: Retrieve list of locations assigned to the current user, 
	that was changed, containing deleted locations
	Given the client had performed a location retrieval earlier
		And several locations were assigned to me before that retrieval
		And a changed set of locations (where some have even been deleted) was assigned to me after that retrieval
	When I request a list of my locations specifying the time of that retrieval
    Then the call should be successful
    	And I should have received a valid location list
        And that list should contain the same locations as assigned after the retrieval
        And that list should contain the locations that were deleted after the retrieval with respective deleted timestamps