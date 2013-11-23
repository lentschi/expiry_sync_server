Feature: User profile update
    A user should be able to update their profile 
    (changing password and deactivating account included)
    
Scenario: Update password and set an email address
    Given a valid user without an email address exists
        And I am logged in with that user
    When I try to update that user with an email address and a new password
    Then the call should be successful
    When I logout
        And I try to login with that user specifying the new password
    Then the call should be successful
    
Scenario Outline: Update password without setting an email address
    Given a valid user without an email address exists
        And I am logged in with that user
    When I try to update that user <in_which_way?>
    Then the call should fail
Examples:
    | in_which_way? |
    | with a new username |
    | without an email address |
    
Scenario: Deactivate account
    Given a valid user exists
        And I am logged in with that user
    When I try to deactivate my account
    Then the call should be successful
    When I perform a login with that user's data
    Then the call should fail