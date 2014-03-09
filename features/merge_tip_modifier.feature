Feature: The author of a merge can alter the size of the tip of the merged commits
  Background:
    Given the tip for commit is "0.01"
    And our fee is "0"

  Scenario:  A simple merge without modifier
    Given the tip modifier for "huge" is "10"
    And a project
    And a deposit of "500"
    And the last known commit is "A"
    And a new commit "B" with parent "A"
    And a new commit "C" with parent "A" and "B"
    And the message of commit "C" is "Great change!"
    When the new commits are read
    Then there should be no tip for commit "A"
    And there should a tip of "5" for commit "B"
    And there should be no tip for commit "C"
    And the new last known commit should be "C"

  Scenario:  A simple merge with a modifier
    Given the tip modifier for "huge" is "10"
    And a project
    And a deposit of "500"
    And the last known commit is "A"
    And a new commit "B" with parent "A"
    And a new commit "C" with parent "A" and "B"
    And the message of commit "C" is "Great change! #huge"
    When the new commits are read
    Then there should be no tip for commit "A"
    And there should a tip of "50" for commit "B"
    And there should be no tip for commit "C"
    And the new last known commit should be "C"

  Scenario:  A merge along with non merged commits
    Given the tip modifier for "tiny" is "0.1"
    And a project
    And a deposit of "1000"
    And the last known commit is "A"
    And a new commit "B" with parent "A"
    And a new commit "C" with parent "B"
    And a new commit "D" with parent "C"
    And a new commit "E" with parent "C" and "D"
    And the message of commit "E" is "#tiny"
    And a new commit "F" with parent "E"
    When the new commits are read
    Then there should be no tip for commit "A"
    And there should a tip of "10" for commit "B"
    And there should a tip of "9.9" for commit "C"
    And there should a tip of "0.9801" for commit "D"
    And there should be no tip for commit "E"
    And there should a tip of "9.791199" for commit "F"
    And the new last known commit should be "F"

  Scenario:  A merge with commits in the 2 branches, the modifier is ignored
    Given the tip modifier for "tiny" is "0.1"
    And a project
    And a deposit of "1000"
    And the last known commit is "A"
    And a new commit "B" with parent "A"
    And a new commit "C" with parent "B"
    And a new commit "D" with parent "B"
    And a new commit "E" with parent "C" and "D"
    And the message of commit "E" is "#tiny"
    And a new commit "F" with parent "E"
    When the new commits are read
    Then there should be no tip for commit "A"
    And there should a tip of "10" for commit "B"
    And there should a tip of "9.9" for commit "C"
    And there should a tip of "9.801" for commit "D"
    And there should be no tip for commit "E"
    And there should a tip of "9.70299" for commit "F"
    And the new last known commit should be "F"

  Scenario:  A merge when no modifiers are defined
    Given there's no tip modifier defined
    And a project
    And a deposit of "1000"
    And the last known commit is "A"
    And a new commit "B" with parent "A"
    And a new commit "C" with parent "A" and "B"
    When the new commits are read
    Then there should be no tip for commit "A"
    And there should a tip of "10" for commit "B"
    And there should be no tip for commit "C"
