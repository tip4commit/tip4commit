Feature: A project collaborator can display the tipping policies of the project
  Background:
    Given a project
    And the project collaborators are:
      | seldon  |
      | daneel  |

  Scenario: A collaborator changes the tipping policies
    Given I'm logged in as "seldon"
    And I go to the project page
    And I click on "Change project settings"
    And I fill "Tipping policies" with:
      """
      All commits are huge!

      Blah blah
      """
    And I click on "Save the project settings"
    Then I should see "The project settings have been updated"

    Given I'm not logged in
    And I go to the project page
    Then I should see "All commits are huge!"
    And I should see "Blah blah"
    And I should see "seldon"
