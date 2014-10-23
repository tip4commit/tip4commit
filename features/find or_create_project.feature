Feature: Visitors may search for and add projects
  Background:
    Given a project

  Scenario: Visitors may find existing projects
    Given I'm not logged in
    And I go to the "projects" page
    And I fill "query" with: "example"
    And I click on "Find or add project"
    Then I should see "example/test"
    And There should not be a project avatar image

  Scenario: Visitors may not find non-existing projects
    Given I'm not logged in
    And I go to the "projects" page
    And I fill "query" with: "no-such-repo"
    And I click on "Find or add project"
    Then I should not see "example/test"

  Scenario: Visitors may add new projects
    Given I'm not logged in
    And I go to the "projects" page
    And I fill "query" with: "https://github.com/tip4commit/tip4commit"
    And I click on "Find or add project"
    Then I should see "tip4commit/tip4commit"
    And I should not see "example/test"
    And There should be a project avatar image

  Scenario: Visitors may not add non-existing projects
    Given I'm not logged in
    And I go to the "projects" page
    And I fill "query" with: "https://github.com/xxx-no-such-user-xxx/xxx-no-such-repo-xxx"
    And I click on "Find or add project"
    Then I should not see "xxx-no-such-repo-xxx"
    And I should not see "example/test"

  Scenario: Visitors may not add bogus projects
    Given I'm not logged in
    And I go to the "projects" page
    And I fill "query" with: "https://shithub.com/nouser/norepo"
    And I click on "Find or add project"
    Then I should not see "norepo"
    And I should not see "example/test"

