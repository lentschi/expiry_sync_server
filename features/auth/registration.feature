Feature: Registration
	As a mobile user I should be able to register
	
Scenario: Register a new user with valid data
	When I try to register with valid data
    Then the call should be successful
    	And I should have received a valid access token

Scenario Outline: Register a new user with invalid data
	When I try to register <in_which_way?>
	Then the call should fail
	   And I should have received errors on the <error_field> field 
Examples:
	| in_which_way? | error_field |
	| omitting the username | username |
	| with an invalid username | username |
	| with an invalid email address | email |