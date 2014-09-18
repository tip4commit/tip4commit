Feature: Users should not be notified if their balance is small
  Background:
    Given a project "django"
    And a deposit of "0.1"
    And 2 new commits

  Scenario: Without big deposits
    When the new commits are read
    Then there should be 0 email sent

  Scenario: User's balance hits threshold
    When 100 new commits
    And the new commits are read
    Then there should be 1 email sent

  Scenario: With bigger donation
    When a deposit of "2"
    And the new commits are read
    Then there should be 1 email sent