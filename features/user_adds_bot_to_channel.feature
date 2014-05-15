Feature: user adds bot to channel
  So that I can have the bot on my channel
  As a broadcaster
  I want to add the bot to my channel

  Scenario: not on channel already
    Given the bot is listening for metacommands on "gettherebot"
    And I am chatting as "darkest_mage"
    When I type "!join" in "gettherebot"
    Then the bot joins the channel "darkest_mage"
    And I should see "joined channel 'darkest_mage'"

  Scenario: already on channel
    Given the bot has joined the channel "numotthenummy"
    And the bot is listening for metacommands on "gettherebot"
    And I am chatting as "numotthenummy"
    When I type "!join" in "gettherebot"
    Then I should see "already joined channel 'numotthenummy'"
