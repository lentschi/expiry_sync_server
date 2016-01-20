Feature: Everyone should be able to list all the alternate servers

Background: 
	Given a valid user exists
    	And I am logged in with that user in my web browser
	Given there exist several servers

Scenario: Listing all the servers using the website
	When I open the server list on the website
		Then I should see those servers

Scenario: Listing all the servers using the website
	When I try to retrieve the index of alternate servers
		Then the call should be successful
		And I should have received those servers