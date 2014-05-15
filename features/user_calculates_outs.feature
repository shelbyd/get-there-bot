Feature: user calculates outs

  Scenario Outline: commands
    Given the bot has joined the channel "channel"
    When I type <command> in "channel"
    Then I should see <result>

    Examples:
      | command                      | result   |
      | "!calculate_outs 5"          | "20.0%"  |
      | "!calculate-outs 5"          | "20.0%"  |
      | "!calculate_outs 5 2"        | "40.0%"  |
      | "!calculate_outs 33 9 3"     | "62.9%"  |
      | "!calculate_outs 33 --draws 3 9"| "62.9%"|
      | "!calculate_outs 33 --draws 3 --outs 9"| "62.9%"|
      | "!calculate_outs --outs 9 33 --draws 3"| "62.9%"|
      | "!calculate_outs --outs 9 --draws 3 33"| "62.9%"|
      | "!calculate_outs --outs 9 --draws 3 --cards 33"| "62.9%"|

      | "!calculate_outs asdf" | "invalid command '!calculate_outs asdf'" |
      | "!calculate_outs 3 --outs" | "invalid command '!calculate_outs 3 --outs'" |
