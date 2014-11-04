Feature: Collaborators may manage project
  Background:
    Given a "github" project named "seldon/seldons-project" exists

  Scenario: Collaborators must be signed in to manage project
    Given I'm not signed in
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "seldon/seldons-project"
    And   I should see "Pending initial sync"
    But   I should not see "Change project settings"
    And   I should not see "Decide tips"

    When the project syncs with the remote repo
    And  I visit the "seldon/seldons-project github-project" page
    Then I should be on the "seldon/seldons-project github-project" page
    And  I should see "seldon/seldons-project"
    But  I should not see "Pending initial sync"
    And  I should not see "Change project settings"
    And  I should not see "Decide tips"

  Scenario: Non-collaborators should not be able to manage project
    Given I'm signed in as "someone-else"
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "seldon/seldons-project"
    And   I should see "Pending initial sync"
    But   I should not see "Change project settings"
    And   I should not see "Decide tips"

    When the project syncs with the remote repo
    And  I visit the "seldon/seldons-project github-project" page
    Then I should be on the "seldon/seldons-project github-project" page
    And  I should see "seldon/seldons-project"
    But  I should not see "Pending initial sync"
    And  I should not see "Change project settings"
    And  I should not see "Decide tips"

  Scenario: New projects should show "Pending initial sync"
    Given I'm signed in as "seldon"
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "seldon/seldons-project"
    And   I should see "Pending initial sync"
    But   I should not see "Change project settings"
    And   I should not see "Decide tips"

    When the project syncs with the remote repo
    And  I visit the "seldon/seldons-project github-project" page
    Then I should be on the "seldon/seldons-project github-project" page
    And  I should see "seldon/seldons-project"
    But  I should not see "Pending initial sync"
    And  I should see "Change project settings"
    But  I should not see "Decide tips"
