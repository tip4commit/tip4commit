Feature: Collaborators may manage project
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    # NOTE: "seldon" is automatically a collaborator


  Scenario: Visitors may not manage projects
    Given I'm not signed in
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "seldon/seldons-project"
    And   I should see "Pending initial fetch"
    But   I should not see "Change project settings"
    And   I should not see "Decide tips"

    When the project syncs with the remote repo
    And  I visit the "seldon/seldons-project github-project" page
    Then I should be on the "seldon/seldons-project github-project" page
    And  I should see "seldon/seldons-project"
    But  I should not see "Pending initial fetch"
    And  I should not see "Change project settings"
    And  I should not see "Decide tips"

    When  I visit the "seldon/seldons-project github-project edit" page
    Then  I should be on the "home" page
    And   I should see "You are not authorized to perform this action"

  Scenario: Non-collaborators should not be able to manage project
    Given I'm signed in as "someone-else"
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "seldon/seldons-project"
    And   I should see "Pending initial fetch"
    But   I should not see "Change project settings"
    And   I should not see "Decide tips"

    When the project syncs with the remote repo
    And  I visit the "seldon/seldons-project github-project" page
    Then I should be on the "seldon/seldons-project github-project" page
    And  I should see "seldon/seldons-project"
    But  I should not see "Pending initial fetch"
    And  I should not see "Change project settings"
    And  I should not see "Decide tips"

    When  I visit the "seldon/seldons-project github-project edit" page
    Then  I should be on the "home" page
    And   I should see "You are not authorized to perform this action"

  Scenario: New projects should show "Pending initial fetch" in place of edit button
    Given I'm signed in as "seldon"
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "seldon/seldons-project"
    And   I should see "Pending initial fetch"
    But   I should not see "Change project settings"
    And   I should not see "Decide tips"

    When the project syncs with the remote repo
    And  I visit the "seldon/seldons-project github-project" page
    Then I should be on the "seldon/seldons-project github-project" page
    And  I should see "seldon/seldons-project"
    But  I should not see "Pending initial fetch"
    And  I should see "Change project settings"
    But  I should not see "Decide tips"

  Scenario: Collaborators may sign in to manage project
    Given I'm signed in as "seldon"
    When  the project syncs with the remote repo
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "seldon/seldons-project"
    And   I should see "Change project settings"
    But   I should not see "Pending initial fetch"
    And   I should not see "Decide tips"

    When I click "Change project settings"
    Then I should be on the "seldon/seldons-project github-project edit" page
    And  I should see "seldon/seldons-project project settings"
    When I click "Save the project settings"
    Then I should be on the "seldon/seldons-project github-project" page
    And  I should see "The project settings have been updated"
