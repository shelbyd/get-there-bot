Feature: user calculates outs

  Scenario Outline: commands
    When I type <command>
    Then I should see <result>

    Examples:
      | command                      | result   |
      | "!calculate_outs 3"          | "33.33%" |
      | "!calculate_outs 3 --outs 2" | "66.67%" |
      | "calculate_outs 3 --outs 2"  | nil      |