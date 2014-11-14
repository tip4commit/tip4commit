Feature: Visitors may search for and add projects
  Given I'm not signed in


  Scenario: Visitors may find existing projects
    Given a "github" project named "tip4commit/tip4commit" exists
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    And   I should see "tip4commit/tip4commit"

    When  I fill "query" with: "tip4commit/tip4commit"
    And   I click "Find project"
    Then  I should be on the "tip4commit/tip4commit github-project" page
    And   I should see "tip4commit/tip4commit"
    But   I should not see "Project not found"

  Scenario: Visitors may not find non-existing projects
    Given I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "no-such-repo"
    And   I click "Find project"
    Then  I should be on the "search" page
    And   I should see "Project not found"
    But   I should not see "no-such-repo"

  Scenario: Visitors may not add new projects
    Given I visit the "projects" page
    Then  I should be on the "projects" page
    When  I fill "query" with: "https://github.com/tip4commit/tip4commit"
    And   I click "Find project"
    Then  I should be on the "search" page
    And   I should see "Project not found"
    But   I should not see "tip4commit/tip4commit"

  Scenario: Projects with individual owner should not show project avatar
    Given a "github" project named "seldon/seldons-project" exists
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    And   I should see "seldon/seldons-project"
    And   there should not be a project avatar image visible

    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page
    And   I should see "seldon/seldons-project"
    And   there should not be a project avatar image visible

  Scenario: Projects owned by an organization should show project avatar
    Given a "real-github" project named "tip4commit/tip4commit" exists
    And   I visit the "projects" page
    Then  I should be on the "projects" page
    And   I should see "tip4commit/tip4commit"
    And   there should be a project avatar image visible

    When  I visit the "tip4commit/tip4commit github-project" page
    Then  I should be on the "tip4commit/tip4commit github-project" page
    And   I should see "tip4commit/tip4commit"
    And   there should be a project avatar image visible
