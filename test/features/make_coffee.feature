Feature: Coffee machine serves coffee
  As a customer
  I want to get coffee from the machine
  The machine has to have enough money deposited
  and it has to have enough coffee

  Scenario: Coffee machine makes coffee when there's enough coffee and money
    Given There's a coffee machine with 10 doses of coffee in it
    And I as a customer deposit $10 inside
    When I press the coffee button
    Then I should be served a coffee

  Scenario: Coffee machine can make espresso
    Given There's a coffee machine with 10 doses of coffee in it
    And I as a customer deposit $10 inside
    When I press the espresso button
    Then I should be served espresso
