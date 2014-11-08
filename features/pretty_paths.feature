Feature: The site routes pretty paths uniformly
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    And   a user named "seldon" exists with a bitcoin address
    And   a user named "yugo" exists without a bitcoin address


  ### Project routes ###

  Scenario: Project index page is accessible via standard path
    When  I visit the "projects" page
    Then  I should be on the "projects" page

  Scenario: Project show page is accessible via project name
    When  I visit the "seldon/seldons-project github-project" page
    Then  I should be on the "seldon/seldons-project github-project" page

  Scenario: Project show page is accessible via project id
    When  I browse to the explicit path "projects/1"
    Then  I should be on the "seldon/seldons-project github-project" page

  Scenario: Project edit page is accessible via project name
    Given I'm signed in as "seldon"
    When  the project syncs with the remote repo
    And   I visit the "seldon/seldons-project github-project edit" page
    Then  I should be on the "seldon/seldons-project github-project edit" page

  Scenario: Project edit page is accessible via project id
    Given I'm signed in as "seldon"
    When  the project syncs with the remote repo
    And   I browse to the explicit path "projects/1/edit"
    Then  I should be on the "seldon/seldons-project github-project edit" page

  Scenario: Project decide_tip_amounts page is accessible via project name
    Given I'm signed in as "seldon"
    When  the project syncs with the remote repo
    When  I visit the "seldon/seldons-project github-project decide_tip_amounts" page
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page

  Scenario: Project decide_tip_amounts page is accessible via project id
    Given I'm signed in as "seldon"
    When  the project syncs with the remote repo
    When  I browse to the explicit path "projects/1/decide_tip_amounts"
    Then  I should be on the "seldon/seldons-project github-project decide_tip_amounts" page

  Scenario: Project tips page is accessible via project name
    When  I visit the "seldon/seldons-project github-project tips" page
    Then  I should be on the "seldon/seldons-project github-project tips" page

  Scenario: Project tips page is accessible via project id
    When  I browse to the explicit path "projects/1/tips"
    Then  I should be on the "seldon/seldons-project github-project tips" page

  Scenario: Project deposits page is accessible via project name
    When  I visit the "seldon/seldons-project github-project deposits" page
    Then  I should be on the "seldon/seldons-project github-project deposits" page

  Scenario: Project deposits page is accessible via project id
    When  I browse to the explicit path "projects/1/deposits"
    Then  I should be on the "seldon/seldons-project github-project deposits" page

  Scenario: Unknown project show page via project name redirects to projects page
    When  I visit the "yugo/yugos-project github-project" page
    Then  I should be on the "projects" page

  Scenario: Unknown project show page via project id redirects to projects page
    When  I browse to the explicit path "projects/999999"
    Then  I should be on the "projects" page

  Scenario: Unknown project edit page via project name redirects to projects page
    When  I visit the "yugo/yugos-project github-project edit" page
    Then  I should be on the "projects" page

  Scenario: Unknown project edit page via project id redirects to projects page
    When  I browse to the explicit path "projects/999999/edit"
    Then  I should be on the "projects" page

  Scenario: Unknown project decide_tip_amounts page via project name redirects to projects page
    When  I visit the "yugo/yugos-project github-project decide_tip_amounts" page
    Then  I should be on the "projects" page

  Scenario: Unknown project decide_tip_amounts page via project id redirects to projects page
    When  I browse to the explicit path "projects/999999/decide_tip_amounts"
    Then  I should be on the "projects" page

  Scenario: Unknown project tips page via project name redirects to projects page
    When  I visit the "yugo/yugos-project github-project tips" page
    Then  I should be on the "projects" page

  Scenario: Unknown project tips page via project id redirects to projects page
    When  I browse to the explicit path "projects/999999/tips"
    Then  I should be on the "projects" page

  Scenario: Unknown project deposits page via project name redirects to projects page
    When  I visit the "yugo/yugos-project github-project deposits" page
    Then  I should be on the "projects" page

  Scenario: Unknown project deposits page via project id redirects to projects page
    When  I browse to the explicit path "projects/999999/deposits"
    Then  I should be on the "projects" page


  ### User routes ###

  Scenario: User index page is accessible via standard path
    When  I visit the "users" page
    Then  I should be on the "users" page

  Scenario: User show page is inaccessible via user name when not signed in
    When  I visit the "seldon user" page
    Then  I should be on the "sign_in" page
    And   I should see "You need to sign in or sign up before continuing"

  Scenario: User show page is inaccessible via user id when not signed in
    When  I browse to the explicit path "users/1"
    Then  I should be on the "sign_in" page
    And   I should see "You need to sign in or sign up before continuing"

  Scenario: User show page is inaccessible via user name to other users
    Given I'm signed in as "yugo"
    When  I visit the "seldon user" page
    Then  I should be on the "home" page
    And   I should see "You are not authorized to perform this action"

  Scenario: User show page is inaccessible via user id to other users
    Given I'm signed in as "yugo"
    When  I browse to the explicit path "users/1"
    Then  I should be on the "home" page
    And   I should see "You are not authorized to perform this action"

  Scenario: User show page is accessible via user name to that user
    Given I'm signed in as "seldon"
    When  I visit the "seldon user" page
    Then  I should be on the "seldon user" page
    And   I should see "seldon Balance 0.00000000 Ƀ"
    And   I should see "E-mail seldon@example.com"
    And   I should see "Bitcoin address"

  Scenario: User show page is accessible via user id to that user
    Given I'm signed in as "seldon"
    When  I browse to the explicit path "users/1"
    Then  I should be on the "seldon user" page
    And   I should see "seldon Balance 0.00000000 Ƀ"
    And   I should see "E-mail seldon@example.com"
    And   I should see "Bitcoin address"

  Scenario: Unknown user tips page user name redirects to users page
    When  I visit the "unknown-user user tips" page
    Then  I should be on the "users" page
    And   I should see "User not found"

  Scenario: Unknown user tips page pretty id redirects to users page
    When  I browse to the explicit path "users/999999/tips"
    Then  I should be on the "users" page
    And   I should see "User not found"

  Scenario: User without bitcoin address tips page via user name redirects to users page
    When  I visit the "yugo user tips" page
    Then  I should be on the "users" page
    And   I should see "User not found"

  Scenario: User without bitcoin address tips page via user id redirects to users page
    When  I browse to the explicit path "users/2/tips"
    Then  I should be on the "users" page
    And   I should see "User not found"

  Scenario: User with bitcoin address tips page is accessible via user name
    When  I visit the "seldon user tips" page
    Then  I should be on the "seldon user tips" page
    And   I should see "seldon tips"

  Scenario: User with bitcoin address tips page is accessible via user id
    When  I browse to the explicit path "users/1/tips"
    Then  I should be on the "seldon user tips" page
    And   I should see "seldon tips"
