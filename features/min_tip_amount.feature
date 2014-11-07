Feature: Admins can set minimum tip amount in the configuration file
  Background:
    Given a project "my-project"
    And our fee is "0"
    And min tip amount is "300"
    And a deposit of "500"
    And the last known commit is "COMMIT1"

  Scenario: Developer gets more than 1% of funds, but less than available_amount
    And a user "yugo" has opted-in
    And a new commit "COMMIT2" with parent "COMMIT1"
    And the author of commit "COMMIT2" is "yugo"
    And a new commit "COMMIT3" with parent "COMMIT2"
    And the author of commit "COMMIT3" is "yugo"
    When the new commits are read
    Then there should be a tip of "300" for commit "COMMIT2"
    And there should be a tip of "200" for commit "COMMIT3"