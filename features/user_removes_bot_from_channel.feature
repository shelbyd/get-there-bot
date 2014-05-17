Feature: user removes bot from channel

  Scenario: bot listening on channel
    Given the bot is listening for metacommands on "gettherebot"
    And the bot has joined the channel "numotthenummy"
    And I am chatting as "numotthenummy"
    When I type "!leave" in "gettherebot"
    Then I should see "left channel 'numotthenummy'"
    And the bot is not on the channel "numotthenummy"
    And the bot has left the channel "numotthenummy"

  Scenario: bot not listening
    Given the bot is listening for metacommands on "gettherebot"
    And I am chatting as "darkest_mage"
    When I type "!leave" in "gettherebot"
    Then I should see "not on channel 'darkest_mage'"
    And the bot is not on the channel "darkest_mage"
