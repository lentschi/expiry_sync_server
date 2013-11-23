Feature: Login
    As a mobile user I should be able to login

Scenario Outline: Login with valid data
    Given a valid user <with_or_without_email?> exists
    When I perform a login with that user's data using <which_login_key?> as login key
    Then the call should be successful
        And I should have received a valid access token
Examples:
    | with_or_without_email? | which_login_key? |
    | without an email address | their username |
    | with an email address | their email address |
    | with an email address | their username |

Scenario: Login with invalid data
    Given a valid user exists
    When I perform a login with invalid login data
    Then the call should fail