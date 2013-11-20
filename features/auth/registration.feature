Feature: Registration
	As a mobile user I should be able to register
	
Scenario: Register a new user with valid data
	When I try to register with valid data
    Then the call should be successful
    	And I should have received a valid access token

Scenario Outline: Register a new user with invalid data
	When I try to register <in_which_way?>
	Then the call should fail
Examples:
	| in_which_way? |
	| omitting my first name |
	| omitting my last name |
	| with a typo in the repeat password field |