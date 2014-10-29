Feature: A project collaborator can change the tips of commits
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    And   the project collaborators are:
      | seldon  |
      | daneel  |
    And   our fee is "0"
    And   a deposit of "500" is made
    And   the most recent commit is "AAA"
    And   a new commit "BBB" with parent "AAA"
    And   a new commit "CCC" with parent "BBB"
    And   the author of commit "BBB" is "yugo"
    And   the author of commit "CCC" is "gaal"

  Scenario: Without anything modified
    When the project syncs with the remote repo
    Then there should be a tip of "5" for commit "BBB"
    And  there should be a tip of "4.95" for commit "CCC"
    And  there should be 2 email sent

  Scenario: A collaborator wants to alter the tips
    Given I'm logged in as "seldon"
    When  the project syncs with the remote repo
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    When  I click on "Change project settings"
    Then  I should be on the "seldon/seldons-project github-project edit" page
    When  I check "Do not send the tips immediatly."
    And   I click on "Save the project settings"
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "The project settings have been updated"

    When  a new commit "DDD" with parent "CCC"
    And   the author of commit "DDD" is "sumdood"
    And   the message of commit "DDD" is "sumdood's tiny commit DDD"
    And   a new commit "EEE" with parent "DDD"
    And   the author of commit "EEE" is "sumotherdood"
    When  the project syncs with the remote repo
    Then  there should be a tip of "5" for commit "BBB"
    And   there should be a tip of "4.95" for commit "CCC"
    And   the tip amount for commit "DDD" should be undecided
    And   there should be 2 email sent

    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    When  I click on "Decide tip amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page
    And   I should not see "AAA"
    And   I should not see "BBB"
    And   I should not see "CCC"
    But   I should see "DDD"
    And   I should see "sumdood's tiny commit DDD"
    And   I should see "EEE"
    And   the most recent commit should be "EEE"

    When  I choose the amount "Tiny: 0.1%" on commit "DDD"
    And   I click on "Send the selected tip amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page
    And   there should be a tip of "0.49005" for commit "DDD"
    And   the tip amount for commit "EEE" should be undecided
    And   there should be 3 email sent

    When  the email counters are reset
    And   I choose the amount "Free: 0%" on commit "EEE"
    And   I click on "Send the selected tip amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page
    And   there should be a tip of "0.49005" for commit "DDD"
    And   there should be a tip of "0" for commit "EEE"
    And   there should be 0 email sent

  Scenario: A non collaborator does not see the settings button
    Given I'm logged in as "yugo"
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should not see "Change project settings"

  Scenario: A non collaborator does not see the decide tip amounts button
    Given the project has undedided tips
    And   I'm logged in as "yugo"
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should not see "Decide tip amounts"

  Scenario: A non collaborator goes to the edit page of a project
    Given I'm logged in as "yugo"
    When  I visit the "seldon/seldons-project github-project edit" page
    Then  I should be on the "home" page
    And   I should see "You are not authorized to perform this action!"

  Scenario: A non collaborator sends a forged update on a project
    Given I'm logged in as "yugo"
    When  I send a forged request to enable tip holding on the project
    Then  I should be on the "home" page
    And   I should see "You are not authorized to perform this action!"
    And   the project should not hold tips

  Scenario: A collaborator sends a forged update on a project
    Given I'm logged in as "daneel"
    When  the project syncs with the remote repo
    When  I send a forged request to enable tip holding on the project
    Then  I should be on the "seldon/seldons-project github-project" page
    And   the project should hold tips

  Scenario Outline: A user sends a forged request to set a tip amount
    When  the project syncs with the remote repo
    Given the project has 1 undecided tip
    When  I'm logged in as "<user>"
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I send a forged request to set the amount of the first undecided tip of the project
    And   the project should have <remaining undecided tips> undecided tips

    Examples:
      | user   | remaining undecided tips |
      | seldon | 0                        |
      | yugo   | 1                        |

  Scenario: A collaborator sends large amounts in tips
    Given 20 new commits are made
    And   a new commit "last"
    And   the project holds tips
    When  the project syncs with the remote repo
    And   I'm logged in as "seldon"
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "Decide tip amounts"
    When  I click on "Decide tip amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page
    When  I choose the amount "Huge: 5%" on all commits
    And   I click on "Send the selected tip amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page
    And   I should see "You can't assign more than 100% of available funds."
    And   the tip amount for commit "BBB" should be undecided
    And   the tip amount for commit "CCC" should be undecided

  Scenario Outline: A collaborator changes the amount of a tip on another project
    Given the project holds tips
    And   the project syncs with the remote repo
    And   a "github" project named "fake/fake" exists
    And   the project collaborators are:
      | bad guy |
    And   a new commit "fake commit"
    And   the project holds tips
    When  the project syncs with the remote repo
    And   I'm logged in as "<user>"
    When  regarding the "github" project named "seldon/seldons-project"
    And   I send a forged request to change the percentage of commit "BBB" to "5"
    Then  <consequences>

    Examples:
      | user    | consequences                                        |
      | seldon  | there should be a tip of "25" for commit "BBB"      |
      | bad guy | the tip amount for commit "BBB" should be undecided |
