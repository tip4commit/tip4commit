Feature: Developers must opt-in to create an account and receive tips
  Background:
    Given a project "my-project"
    And our fee is "0"
    And a deposit of "500"
    And the last known commit is "COMMIT1"

  Scenario: Tipping a opted-in developer
    And a user "yugo" has opted-in
    And a new commit "COMMIT2" with parent "COMMIT1"
    And the author of commit "COMMIT2" is "yugo"
    And the message of commit "COMMIT2" is "Tiny change"
    When the new commits are read
    Then there should be a tip of "5" for commit "COMMIT2"
    And there should be 0 email sent

  Scenario: Tipping a developer that has not opted-in
    And a new commit "COMMIT2" with parent "COMMIT1"
    And the author of commit "COMMIT2" is "yugo"
    And the message of commit "COMMIT2" is "Tiny change"
    When the new commits are read
    Then there should be no tip for commit "COMMIT2"
    And there should be 0 email sent
