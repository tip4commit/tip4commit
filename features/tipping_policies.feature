Feature: A project collaborator can display the tipping policies of the project
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    And   the project collaborators are:
      | seldon  |
      | daneel  |
    And   the project syncs with the remote repo

  Scenario: A collaborator changes the tipping policies
    Given I'm signed in as "daneel"
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I click on "Change project settings"
    And   I fill "Tipping policies" with:
      """
      All commits are huge!

      Blah blah
      """
    And   I click on "Save the project settings"
    Then  I should be on the "seldon/seldons-project github-project" page
    Then  I should see "The project settings have been updated"

    Given I sign out
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    Then  I should see "All commits are huge!"
    And   I should see "Blah blah"
    And   I should see "daneel"
