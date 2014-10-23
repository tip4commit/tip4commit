Feature: Visitors should be able to sign_up and sign_in
  Background:
    Given a project

  Scenario: Visitors should see sign_up and sign_in links on the home page
    Given I'm not logged in
    And I go to the "home" page
    Then I should see "Sign up" in the header
    Then I should see "Sign in" in the header

  Scenario: Visitors should see sign_up and sign_in links on the projects page
    Given I'm not logged in
    And I go to the "projects" page
    Then I should see "Sign up" in the header
    Then I should see "Sign in" in the header

  Scenario: Visitors should see sign_up and sign_in links on a project page
    Given I'm not logged in
    And I go to the "project" page
    Then I should see "Sign up" in the header
    Then I should see "Sign in" in the header

  Scenario: Visitors should see sign_up but not sign_in links on sign_in page
    Given I'm not logged in
    And I go to the "sign_in" page
    Then I should see "Sign up" in the header
    Then I should not see "Sign in" in the header

  Scenario: Visitors should see sign_in but not sign_up links on sign_up page
    Given I'm not logged in
    And I go to the "sign_up" page
    Then I should not see "Sign up" in the header
    Then I should see "Sign in" in the header

  Scenario: Logged in users should not see sign_up nor sign_in links on the project page
    Given I'm logged in as "seldon"
    And I go to the "projects" page
    Then I should not see "Sign up" in the header
    Then I should not see "Sign in" in the header
