Feature: Visitors should be able to sign_up and sign_in
  Background:
    Given a "github" project named "seldon/seldons-project" exists
    And   a user named "seldon" exists without a bitcoin address


  Scenario Outline: Visitors should see sign_up and sign_in links on all pages
    Given I'm not signed in
    When  I visit the <page> page
    Then  I should be on the <page> page
    And   I should see "Sign up" in the "header" area
    And   I should see "Sign in" in the "header" area
    But   I should not see "Sign out" in the "header" area
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
    Given I'm not signed in
    When  I visit the "sign_in" page
    Then  I should be on the "sign_in" page
    And   I should see "Sign up" in the "header" area
    But   I should not see "Sign in" in the "header" area
    And   I should not see "Sign out" in the "header" area

  Scenario: Visitors should see sign_in but not sign_up links on sign_up page
    Given I'm not signed in
    When  I visit the "sign_up" page
    Then  I should be on the "sign_up" page
    And   I should not see "Sign up" in the "header" area
    But   I should see "Sign in" in the "header" area
    And   I should not see "Sign out" in the "header" area

  Scenario Outline: Logged in users should see only sign_out link on every page
    Given I'm signed in as "seldon"
    When  the project syncs with the remote repo
    And   I visit the <page> page
    Then  I should be on the <page> page
    And   I should not see "Sign up" in the "header" area
    And   I should not see "Sign in" in the "header" area
    But   I should see "Sign out" in the "header" area
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

  Scenario: Devise rejects invalid logins
    Given I'm not signed in
    When  I visit the "sign_in" page
    Then  I should be on the "sign_in" page
    And   I should see "Sign in E-mail Password Remember me"
    When  I fill "E-mail" with: "unknown-user@somehost.net"
    And   I fill "Password" with: "unknown-users-password"
    And   I click "Sign in"
    Then  I should be on the "sign_in" page
    And   I should see "Invalid email or password"
    When  I fill "E-mail" with: "seldon@example.com"
    And   I fill "Password" with: "incorrect-password"
    And   I click "Sign in"
    Then  I should be on the "sign_in" page
    And   I should see "Invalid email or password"

  Scenario: Visitors should be able to sign up with an email address
    Given I'm not signed in
    When  I visit the "home" page
    When  I click "Sign up" within the "header" area
    Then  I should be on the "sign_up" page
    And   I should see "Sign up E-mail Password Password confirmation"

    When  I fill "E-mail" with: "new-guy@example.com"
    And   I fill "Password" with: "new-guys-password"
    And   I fill "Password confirmation" with: "NOT-new-guys-password"
    And   I click "Sign up"
# NOTE: this is not the actual behavior of the app
#         validations are client-side and prevent the button from being pressed
#         (this applies to the next two clauses as well)
    Then  I should be on the "users" page
    And   I should see "Password confirmation doesn't match Password"
#       if we were testing with javascript support - this is the actual behavior
#     Then  I should be on the "sign_up" page
#     And   I should see "The password and its confirmation are not same"

    When  I fill "E-mail" with: "new-guy@example.com"
    And   I fill "Password" with: "new-guys-password"
    And   I click "Sign up"
    Then  I should be on the "users" page
    And   I should see "Password confirmation doesn't match Password"
#     Then  I should be on the "sign_up" page
#     And   I should see "The password and its confirmation are not same"
#     And   I should see "The password confirmation is required and can't be empty"

    When  I fill "E-mail" with: "new-guy@example.com"
    And   I fill "Password confirmation" with: "new-guys-password"
    And   I click "Sign up"
    Then  I should be on the "users" page
    And   I should see "Password confirmation doesn't match Password"
#     Then  I should be on the "sign_up" page
#     And   I should see "The password and its confirmation are not same"
#     And   I should see "The password is required and can't be empty"

    When  I fill "E-mail" with: "seldon@example.com"
    And   I fill "Password" with: "new-guys-password"
    And   I fill "Password confirmation" with: "new-guys-password"
    And   I click "Sign up"
    Then  I should be on the "users" page
    And   I should see "E-mail has already been taken"
    And   there should be 0 email sent

    When  I fill "E-mail" with: "new-guy@example.com"
    And   I fill "Password" with: "new-guys-password"
    And   I fill "Password confirmation" with: "new-guys-password"
    And   I click "Sign up"
    Then  I should be on the "home" page
    And   I should see "Sign up or Sign in"
    And   I should see "A message with a confirmation link has been sent"
    And   there should be 1 email sent

    When  I visit the "sign_in" page
    Then  I should be on the "sign_in" page
    And   I should see "Sign in E-mail Password Remember me"
    When  I fill "E-mail" with: "new-guy@example.com"
    And   I fill "Password" with: "new-guys-password"
    And   I click "Sign in"
    Then  I should be on the "sign_in" page
    And   I should see "You have to confirm your account before continuing"

    When  I confirm the email address: "new-guy@example.com"
    Then  I should be on the "sign_in" page
    And   I should see "Your account was successfully confirmed"
    When  I fill "E-mail" with: "new-guy@example.com"
    And   I fill "Password" with: "new-guys-password"
    And   I click "Sign in"
    Then  I should be on the "home" page
    And   I should see "new-guy@example.com / 0.00000000 Ƀ / Sign out"
    And   I should see "Signed in successfully"

   Scenario: Visitors should be able to sign up with GitHub oauth
     Given I'm not signed in
     When  I visit the "sign_up" page
     And   I click "Sign in with Github"
     Then  I should be on the "/login/oauth/authorize" page
     Then  some magic stuff happens in the cloud

     Given a GitHib user named "seldon" exists
     When  I visit the "sign_in" page
     And   I click "Sign in with Github"
     Then  I should be on the "home" page
     And   I should see "seldon / 0.00000000 Ƀ / Sign out"
     And   I should see "Successfully authenticated from GitHub account"

# TODO:
#   Scenario: Users signed up via email should be able to merge via GitHub oauth
