Feature: bot ignores chat, non commands

  Scenario Outline: chat
    When I type <message>
    Then I should see nothing

    Examples:
      | message |
      | "yo dude, waaazuuup" |
      | "hey! how's it going" |
      | "!deckstandard" |
      | "!calculate_something" |
