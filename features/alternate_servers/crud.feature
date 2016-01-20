Feature: Create, update, delete alternate servers

Background:
    Given a valid user exists
    	And I am logged in with that user in my web browser

Scenario Outline: Create an alternate server with valid data
	When I submit the creation form for an alternate server on the website <with_what?>
		Then I should see that the creation of the server succeeded
			And I should see that server in the server list
Examples:
	|with_what?|
	|providing all data|
	|omitting the name|
	|omitting the description|
	|omitting name and description|
	
Scenario Outline: Create an alternate server with invalid data
	When I submit the creation form for an alternate server on the website <with_what?>
		Then I should see that the creation of the server failed
Examples:
	|with_what?|
	|omitting the url|
	|with an url that has been used before|
	|with an invalid url|
