Feature: Users should be able to delete their accounts
  Background:
    Given a developer named "seldon" exists without a bitcoin address
    And   I'm signed in as "seldon"

  @vcr-ignore-params
  Scenario: Users should be able to see delete account button in their profile     
    Given  I visit the "seldon user" page
    Then   I should see "Delete Account"
    When   I click "Delete Account"
    When   I fill "E-mail" with: "seldon@example.com"
    When   I click "Delete this account!"
    Then   I should be on the "home" page
    And    I should see "Your account was deleted"
    And    a developer named "seldon" does not exist
    And    I should see "Sign in" in the "header" area
    And    I should not see "Sign out" in the "header" area

  @vcr-ignore-params
  Scenario: Users should confirm deleting account by entering correct email address     
    Given  I visit the "seldon user" page
    Then   I should see "Delete Account"
    When   I click "Delete Account"
    When   I fill "E-mail" with: "invalid@example.com"
    When   I click "Delete this account!"
    Then   I should be on the "seldon user" page
    And    I should see "Invalid email"
    And    a developer named "seldon" exists
    And    I should see "Sign out" in the "header" area
    And    I should not see "Sign in" in the "header" area