Feature: Location sharing
	The user should be able to retrieve share locations via email
	
Background:
	Given a valid user exists
	Given I am logged in with that user
	
Scenario: Share a location
    Given my user has an email address set
        And a location is assigned to this user
	When I try to share that location by specifying the recipients email address
	Then the call should be successful
	   And there should be an email in the recipients mailbox
	   And this email should contain links to either accept or decline the invitation to that location share
	   
Scenario: Accept an invitation to a location share
    Given my user has an email address set
        And there exists one other user other than me
        And this user has an email address set
        And I have a pending invitation to a location share from that user in my inbox
    When I click the accept link in that email
    Then I should be informed, that I can now access this location
    When I request a list of my locations
    Then I should have received a valid location list
        And that list should contain the same location as assigned before