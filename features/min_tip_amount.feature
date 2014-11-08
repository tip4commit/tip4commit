Feature: Admins can set minimum tip amount in the configuration file
  Background:
    Given a "github" project named "me/my-project" exists
    And   our fee is "0"
    And   the minimum tip amount is "300"
    And   a deposit of "500" is made

  Scenario: Developer gets minimum tip or the remaining available_amount
    Given a developer named "yugo" exists with a bitcoin address
    And   a new commit "COMMIT1" is made by a developer named "yugo"
    And   a new commit "COMMIT2" is made by a developer named "yugo"
    And   a new commit "COMMIT3" is made by a developer named "yugo"
    And   a new commit "COMMIT4" is made by a developer named "yugo"
    When  the project syncs with the remote repo
    Then  there should be a tip of "300" for commit "COMMIT1"
    And   there should be a tip of "200" for commit "COMMIT2"
    And   there should be no tip for commit "COMMIT3"

    When  a deposit of "299" is made
    And   the project syncs with the remote repo
    Then  there should be a tip of "299" for commit "COMMIT3"
    And   there should be no tip for commit "COMMIT4"

    When  a deposit of "1" is made
    And   the project syncs with the remote repo
    Then  there should be a tip of "1" for commit "COMMIT4"
