Feature: Users should not be notified if their balance is small
  Background:
    Given a "github" project named "seldon/seldon-project" exists
    And   a deposit of "0.1" is made
    And   2 new commits are made

  Scenario: Without big deposits
    When the project syncs with the remote repo
    Then there should be 0 email sent

  Scenario: User's balance hits threshold
    When 100 new commits are made
    And  the project syncs with the remote repo
    Then there should be 1 email sent

  Scenario: With bigger donation
    When a deposit of "2" is made
    And  the project syncs with the remote repo
    Then there should be 1 email sent
