Feature: Visitors should be able to sign_up and sign_in
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    And   the project collaborators are:
      | seldon  |

  Scenario Outline: Visitors should see sign_up and sign_in links on all pages
    Given I'm not logged in
    When  I visit the <page> page
    Then  I should be on the <page> page
    And   I should see "Sign up" in the header
    And   I should see "Sign in" in the header
    But   I should not see "Sign out" in the header
    Examples:
      | page                                                       |
      | "home"                                                     |
      | "users"                                                    |
      | "tips"                                                     |
      | "deposits"                                                 |
      | "withdrawals"                                              |
      | "projects"                                                 |
      | "seldon/seldons-project github-project"                    |
      | "seldon/seldons-project github-project tips"               |
      | "seldon/seldons-project github-project deposits"           |

  Scenario: Visitors should see sign_up but not sign_in links on sign_in page
    Given I'm not logged in
    When  I visit the "sign_in" page
    Then  I should be on the "sign_in" page
    And   I should see "Sign up" in the header
    But   I should not see "Sign in" in the header
    And   I should not see "Sign out" in the header

  Scenario: Visitors should see sign_in but not sign_up links on sign_up page
    Given I'm not logged in
    When  I visit the "sign_up" page
    Then  I should be on the "sign_up" page
    And   I should not see "Sign up" in the header
    But   I should see "Sign in" in the header
    And   I should not see "Sign out" in the header

  Scenario Outline: Logged in users should see only sign_out link on every page
    Given I'm logged in as "seldon"
    When  I visit the <page> page
    Then  I should be on the <page> page
    And   I should not see "Sign up" in the header
    And   I should not see "Sign in" in the header
    But   I should see "Sign out" in the header
    Examples:
      | page                                                       |
      | "home"                                                     |
      | "users"                                                    |
      | "tips"                                                     |
      | "deposits"                                                 |
      | "withdrawals"                                              |
      | "projects"                                                 |
      | "seldon/seldons-project github-project"                    |
      | "seldon/seldons-project github-project edit"               |
      | "seldon/seldons-project github-project decide_tip_amounts" |
      | "seldon/seldons-project github-project tips"               |
      | "seldon/seldons-project github-project deposits"           |
