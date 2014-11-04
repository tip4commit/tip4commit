Feature: The site routes pretty paths uniformly
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    And   a user named "yugo" exists with a bitcoin address


  Scenario: Project show page is accessible via pretty path
    When    I visit the "seldon/seldons-project github-project" page
    Then    I should be on the "seldon/seldons-project github-project" page

  Scenario: Project show page is accessible via id
    When    I browse to the explicit path "projects/1"
    Then    I should be on the "seldon/seldons-project github-project" page

  Scenario: Project edit page is accessible via pretty path
    When    I visit the "seldon/seldons-project github-project edit" page
    Then    I should be on the "seldon/seldons-project github-project edit" page

  Scenario: Project show page is accessible via id
    When    I browse to the explicit path "projects/1/edit"
    Then    I should be on the "seldon/seldons-project github-project edit" page

  Scenario: Project decide_tip_amounts page is accessible via pretty path
    When    I visit the "seldon/seldons-project github-project decide_tip_amounts" page
    Then    I should be on the "seldon/seldons-project github-project decide_tip_amounts" page

  Scenario: Project decide_tip_amounts page is accessible via id
    When    I browse to the explicit path "projects/1/decide_tip_amounts"
    Then    I should be on the "seldon/seldons-project github-project decide_tip_amounts" page

  Scenario: Project tips page is accessible via pretty path
    When    I visit the "seldon/seldons-project github-project tips" page
    Then    I should be on the "seldon/seldons-project github-project tips" page

  Scenario: Project tips page is accessible via id
    When    I browse to the explicit path "projects/1/tips"
    Then    I should be on the "seldon/seldons-project github-project tips" page

  Scenario: Project deposits page is accessible via pretty path
    When    I visit the "seldon/seldons-project github-project deposits" page
    Then    I should be on the "seldon/seldons-project github-project deposits" page

  Scenario: Project deposits page is accessible via id
    When    I browse to the explicit path "projects/1/deposits"
    Then    I should be on the "seldon/seldons-project github-project deposits" page
