Feature: Developers may sign-up to receive tip offers
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    And   a developer named "yugo" exists with a bitcoin address
    And   our fee is "0"
    And   a deposit of "500" is made
    And   the most recent commit is "AAA"
    And   a new commit "BBB" is made with parent "AAA"
    And   a new commit "CCC" is made with parent "BBB"
    And   the author of commit "BBB" is "yugo"
    And   the author of commit "CCC" is "gaal"

  Scenario: A commit is merged from an known developer
    When  the project syncs with the remote repo
    Then  there should be a tip of "5" for commit "BBB"
    And   there should be 0 email sent

  Scenario: A commit is merged from an unknown developer
    When  the project syncs with the remote repo
    Then  there should be no tip for commit "CCC"
    And   there should be 0 email sent

  Scenario: A developer signs-up to receive tip offers
    When  the project syncs with the remote repo
    Then  there should be no tip for commit "CCC"
    And   there should be 0 email sent

    When  I sign in as "gaal"
    And   a new commit "DDD" is made by a developer named "gaal"
    When  the project syncs with the remote repo
    Then  there should be a tip of "4.95" for commit "CCC"
    Then  there should be a tip of "4.9005" for commit "DDD"
    And   there should be 0 email sent
