Feature: A project collaborator can change the tips of commits
  Background:
    Given a project "a"
    And the project collaborators are:
      | seldon  |
      | daneel  |
    And our fee is "0"
    And a deposit of "500"
    And the last known commit is "AAA"
    And a new commit "BBB" with parent "AAA"
    And a new commit "CCC" with parent "BBB"
    And the author of commit "BBB" is "yugo"
    And the message of commit "BBB" is "Tiny change"
    And the author of commit "CCC" is "gaal"

  Scenario: Without anything modified
    When the new commits are read
    Then there should be a tip of "5" for commit "BBB"
    And there should be a tip of "4.95" for commit "CCC"
    And there should be 2 email sent

  Scenario: A collaborator wants to alter the tips
    Given I'm logged in as "seldon"
    And I go to the project page
    And I click on "Change project settings"
    And I check "Do not send the tips immediatly. Give collaborators the ability to modify the tips before they're sent"
    And I click on "Save the project settings"
    Then I should see "The project settings have been updated"

    When the new commits are read
    Then the tip amount for commit "BBB" should be undecided
    And the tip amount for commit "CCC" should be undecided
    And there should be 0 email sent

    When I go to the project page
    And I click on "Decide tip amounts"
    Then I should see "BBB"
    And I should see "Tiny change"
    And I should see "CCC"
    And I should not see "AAA"

    When I choose the amount "Tiny: 0.1%" on commit "BBB"
    And I click on "Send the selected tip amounts"
    Then there should be a tip of "0.5" for commit "BBB"
    And the tip amount for commit "CCC" should be undecided
    And there should be 1 email sent

    When the email counters are reset
    And I choose the amount "Free: 0%" on commit "CCC"
    And I click on "Send the selected tip amounts"
    Then there should be a tip of "0.5" for commit "BBB"
    And there should be a tip of "0" for commit "CCC"
    And there should be 0 email sent

  Scenario: A non collaborator does not see the settings button
    Given I'm logged in as "yugo"
    And I go to the project page
    Then I should not see "Change project settings"

  Scenario: A non collaborator does not see the decide tip amounts button
    Given the project has undedided tips
    And I'm logged in as "yugo"
    And I go to the project page
    Then I should not see "Decide tip amounts"

  Scenario: A non collaborator goes to the edit page of a project
    Given I'm logged in as "yugo"
    When I go to the edit page of the project
    Then I should see an access denied

  Scenario: A non collaborator sends a forged update on a project
    Given I'm logged in as "yugo"
    When I send a forged request to enable tip holding on the project
    Then I should see an access denied
    And the project should not hold tips

  Scenario: A collaborator sends a forged update on a project
    Given I'm logged in as "daneel"
    When I send a forged request to enable tip holding on the project
    Then the project should hold tips

  Scenario Outline: A user sends a forged request to set a tip amount
    Given the project has 1 undecided tip
    And I'm logged in as "<user>"
    And I go to the project page
    And I send a forged request to set the amount of the first undecided tip of the project
    Then the project should have <remaining undecided tips> undecided tips

    Examples:
      | user   | remaining undecided tips |
      | seldon | 0                        |
      | yugo   | 1                        |

  Scenario: A collaborator sends large amounts in tips
    Given 20 new commits
    And a new commit "last"
    And the project holds tips
    When the new commits are read
    And I'm logged in as "seldon"
    And I go to the project page
    And I click on "Decide tip amounts"
    And I choose the amount "Huge: 5%" on all commits
    And I click on "Send the selected tip amounts"
    Then there should be a tip of "25" for commit "BBB"
    And there should be a tip of "8.08833862" for commit "last"

  Scenario Outline: A collaborator changes the amount of a tip on another project
    Given the project holds tips
    And the new commits are read
    And a project "fake"
    And the project collaborators are:
      | bad guy |
    And a new commit "fake commit"
    And the project holds tips
    When the new commits are read
    And I'm logged in as "<user>"
    And I send a forged request to change the percentage of commit "BBB" on project "a" to "5"
    Then <consequences>

    Examples:
      | user    | consequences                                        |
      | seldon  | there should be a tip of "25" for commit "BBB"      |
      | bad guy | the tip amount for commit "BBB" should be undecided |

