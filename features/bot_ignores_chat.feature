Feature: bot ignores chat, non commands

  Scenario Outline: chat
    Given the bot has joined the channel "#channel"
    When I type <message> in "#channel"
    Then I should see nothing

    Examples:
      | message |
      | "yo dude, waaazuuup" |
      | "hey! how's it going" |
      | "!deckstandard" |
      | "!calculate_something" |

  Scenario: other chats
    When I type "!calculate_outs 3" in "#some_channel"
    Then I should see nothing
