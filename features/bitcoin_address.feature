Feature: Users should be able to change their bitcoin address
  Background:
    Given a developer named "seldon" exists without a bitcoin address
    And   I'm signed in as "seldon"

  @vcr-ignore-params
  Scenario: Users should be able to set P2PKH address
    Given  I visit the "seldon user" page
    Then   I should see "Bitcoin address"
    When   I fill "Bitcoin address" with: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2"
    And    I click "Update user info"
    Then   I should see "Your information saved!"

 @vcr-ignore-params
  Scenario: Users should not be able to set invalid P2PKH address
    Given  I visit the "seldon user" page
    Then   I should see "Bitcoin address"
    When   I fill "Bitcoin address" with: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVA"
    And    I click "Update user info"
    Then   I should not see "Your information saved!"
    And    I should see "Bitcoin address is invalid"

  @vcr-ignore-params
  Scenario: Users should be able to set P2SH address
    Given  I visit the "seldon user" page
    Then   I should see "Bitcoin address"
    When   I fill "Bitcoin address" with: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy"
    And    I click "Update user info"
    Then   I should see "Your information saved!"

 @vcr-ignore-params
  Scenario: Users should not be able to set invalid P2SH address
    Given  I visit the "seldon user" page
    Then   I should see "Bitcoin address"
    When   I fill "Bitcoin address" with: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLA"
    And    I click "Update user info"
    Then   I should not see "Your information saved!"
    And    I should see "Bitcoin address is invalid"

 @vcr-ignore-params
  Scenario: Users should not be able to set testnet address
    Given  I visit the "seldon user" page
    Then   I should see "Bitcoin address"
    When   I fill "Bitcoin address" with: "mtXWDB6k5yC5v7TcwKZHB89SUp85yCKshy"
    And    I click "Update user info"
    Then   I should not see "Your information saved!"
    And    I should see "Bitcoin address is invalid"

  @vcr-ignore-params
  Scenario: Users should be able to set Bech32 P2WPKH address
    Given  I visit the "seldon user" page
    Then   I should see "Bitcoin address"
    When   I fill "Bitcoin address" with: "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"
    And    I click "Update user info"
    Then   I should see "Your information saved!"

  @vcr-ignore-params
  Scenario: Users should be able to set Bech32 P2WSH address
    Given  I visit the "seldon user" page
    Then   I should see "Bitcoin address"
    When   I fill "Bitcoin address" with: "bc1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3qccfmv3"
    And    I click "Update user info"
    Then   I should see "Your information saved!"

 @vcr-ignore-params
  Scenario: Users should not be able to set testnet Bech32 address
    Given  I visit the "seldon user" page
    Then   I should see "Bitcoin address"
    When   I fill "Bitcoin address" with: "tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx"
    And    I click "Update user info"
    Then   I should not see "Your information saved!"
    And    I should see "Bitcoin address is invalid"