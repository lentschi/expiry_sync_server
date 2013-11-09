Feature: Mobile user login
	As a mobile user I want to be able to login to the server backend
	
	Background:
		Given the following users exist:
		| email | password | 
        | mobile@test.com  | secret |
        
	Scenario: Login with a valid user
        When I perform an API login with:
    	| email | password | 
    	| mobile@test.com  | secret |
        Then the API call should be successful
        	And I should have received a valid access token