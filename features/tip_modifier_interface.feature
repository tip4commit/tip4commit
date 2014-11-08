Feature: A project collaborator can change the tips of commits
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    And   the project collaborators are:
      | seldon  |
      | daneel  |
    And   a user named "yugo" exists with a bitcoin address
    And   a user named "gaal" exists without a bitcoin address
    And   our fee is "0"
    And   a deposit of "500" is made
    And   the most recent commit is "AAA"
    And   a new commit "BBB" is made with parent "AAA"
    And   a new commit "CCC" is made with parent "BBB"
    And   the author of commit "BBB" is "yugo"
    And   the author of commit "CCC" is "gaal"

  Scenario: Without anything modified
    When the project syncs with the remote repo
    Then there should be a tip of "5" for commit "BBB"
    And  there should be a tip of "4.95" for commit "CCC"
    And  there should be 0 email sent

  Scenario: A collaborator wants to alter the tips
    Given I'm signed in as "seldon"
    When  the project syncs with the remote repo
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    When  I click "Change project settings"
    Then  I should be on the "seldon/seldons-project github-project edit" page
    When  I check "Do not send the tips immediately. Give collaborators the ability to modify the tips before they're sent"
    And   I click "Save the project settings"
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "The project settings have been updated"

    When  a new commit "DDD" is made with parent "CCC"
    And   the author of commit "DDD" is "yugo"
    And   the message of commit "DDD" is "yugo's trivial commit DDD"
    And   a new commit "EEE" is made with parent "DDD"
    And   the author of commit "EEE" is "gaal"
    And   the message of commit "EEE" is "gaal's tiny commit EEE"
    When  a new commit "FFF" is made with parent "EEE"
    And   the author of commit "FFF" is "newguy"
    And   the message of commit "FFF" is "newguy's unrewarded commit EEE"
    When  the project syncs with the remote repo
    Then  there should be a tip of "5" for commit "BBB"
    And   there should be a tip of "4.95" for commit "CCC"
    And   the tip amount for commit "DDD" should be undecided
    And   the tip amount for commit "EEE" should be undecided
    But   there should be no tip for commit "FFF"
    And   there should be 0 email sent

    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    When  I click "Decide tip amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page
    And   I should not see "AAA"
    And   I should not see "BBB"
    And   I should not see "CCC"
    But   I should see "DDD"
    And   I should see "yugo's trivial commit DDD"
    And   I should see "EEE"
    And   I should see "gaal's tiny commit EEE"
    But   I should not see "FFF"
    And   I should not see "newguy's unrewarded commit FFF"
    And   the most recent commit should be "FFF"

    When  I choose the amount "Free: 0%" on commit "DDD"
    And   I click "Send the selected tip amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page
    And   I should see "The tip amounts have been defined"
    And   there should be a tip of "0" for commit "DDD"
    And   the tip amount for commit "EEE" should be undecided
    But   there should be no tip for commit "FFF"
    And   there should be 0 email sent

    When  the email counters are reset
    And   I choose the amount "Tiny: 0.1%" on commit "EEE"
    And   I click "Send the selected tip amounts"
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "The tip amounts have been defined"
    And   there should be a tip of "0" for commit "DDD"
    And   there should be a tip of "0.49005" for commit "EEE"
    But   there should be no tip for commit "FFF"
    And   there should be 0 email sent

  Scenario: A non collaborator does not see the settings button
    Given I'm signed in as "yugo"
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should not see "Change project settings"

  Scenario: A non collaborator does not see the decide tip amounts button
    Given the project has undedided tips
    And   I'm signed in as "yugo"
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should not see "Decide tip amounts"

  Scenario: A non collaborator goes to the edit page of a project
    Given I'm signed in as "yugo"
    When  I visit the "seldon/seldons-project github-project edit" page
    Then  I should be on the "home" page
    And   I should see "You are not authorized to perform this action!"

  Scenario: A non collaborator sends a forged update on a project
    Given I'm signed in as "yugo"
    When  I send a forged request to enable tip holding on the project
    Then  I should be on the "home" page
    And   I should see "You are not authorized to perform this action!"
    And   the project should not hold tips

  Scenario: A collaborator sends a forged update on a project
    Given I'm signed in as "daneel"
    When  the project syncs with the remote repo
    When  I send a forged request to enable tip holding on the project
    Then  I should be on the "seldon/seldons-project github-project" page
    And   the project should hold tips

  Scenario Outline: A user sends a forged request to set a tip amount
    When  the project syncs with the remote repo
    Given the project has 1 undecided tip
    When  I'm signed in as "<user>"
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I send a forged request to set the amount of the first undecided tip of the project
    And   the project should have <remaining undecided tips> undecided tips

    Examples:
      | user   | remaining undecided tips |
      | seldon | 0                        |
      | yugo   | 1                        |

  Scenario: A collaborator sends large amounts in tips
    Given 20 new commits are made by a user named "yugo"
    And   a new commit "last" is made
    And   the project holds tips
    When  the project syncs with the remote repo
    And   I'm signed in as "seldon"
    And   I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "Decide tip amounts"
    When  I click "Decide tip amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page
    When  I choose the amount "Huge: 5%" on all commits
    And   I click "Send the selected tip amounts"
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
    And   a new commit "fake commit" is made
    And   the project holds tips
    When  the project syncs with the remote repo
    And   I'm signed in as "<user>"
    When  regarding the "github" project named "seldon/seldons-project"
    And   I send a forged request to change the percentage of commit "BBB" to "5"
    Then  <consequences>

    Examples:
      | user    | consequences                                        |
      | seldon  | there should be a tip of "25" for commit "BBB"      |
      | bad guy | the tip amount for commit "BBB" should be undecided |
