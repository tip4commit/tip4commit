Feature: Visitors may search for and add projects
  Background:
    Given a "github" project named "seldon/seldons-project" exists

  Scenario: Visitors may find existing projects
    Given I'm not signed in
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "seldons-project"
    And   I click "Find or add project"
    Then  I should be on the "search" page
    And   I should see "seldon/seldons-project"
    But   I should not see "project not found"

  Scenario: Visitors may not find non-existing projects
    Given I'm not signed in
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "no-such-repo"
    And   I click "Find or add project"
    Then  I should be on the "search" page
    And   I should see "Project not found"
    But   I should not see "seldon/seldons-project"

  Scenario: Visitors may add new projects
    Given I'm not signed in
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "https://github.com/tip4commit/tip4commit"
    And   I click "Find or add project"
    Then  I should be on the "tip4commit/tip4commit github-project" page
    And   I should see "tip4commit/tip4commit"
    But   I should not see "seldon/seldons-project"

  Scenario: Visitors may not add non-existing projects
    Given I'm not signed in
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "https://github.com/xxx-no-such-user-xxx/xxx-no-such-repo-xxx"
    And   I click "Find or add project"
    Then  I should be on the "search" page
    And   I should see "Project not found"
    But   I should not see "xxx-no-such-repo-xxx"
    And   I should not see "seldon/seldons-project"

  Scenario: Visitors may not add bogus projects
    Given I'm not signed in
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "https://shithub.com/nouser/norepo"
    And   I click "Find or add project"
    Then  I should be on the "search" page
    And   I should see "Project not found"
    But   I should not see "norepo"
    And   I should not see "seldon/seldons-project"

  Scenario: Projects with individual owner should not show project avatar
    Given I'm not signed in
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "seldons-project"
    And   I click "Find or add project"
    Then  I should be on the "search" page
    And   I should see "seldon/seldons-project"
    And   there should not be a project avatar image visible

  Scenario: Projects owned by an organization should show project avatar
    Given I'm not signed in
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "https://github.com/tip4commit/tip4commit"
    And   I click "Find or add project"
    Then  I should be on the "tip4commit/tip4commit github-project" page
    And   I should see "tip4commit/tip4commit"
    And   there should be a project avatar image visible
