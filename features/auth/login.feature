Feature: Login
    As a mobile user I should be able to login

Scenario: Login with valid data
    Given a valid user exists
    When I perform a login with that user's data
    Then the call should be successful
        And I should have received a valid access token

Scenario: Login with invalid data
    Given a valid user exists
    When I perform a login with invalid login data
    Then the call should fail