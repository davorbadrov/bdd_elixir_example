defmodule MakeCoffeeFeatureTest do
  use Cabbage.Feature, async: false, file: "make_coffee.feature"
  alias BddElixir.{Coffee, CoffeeMachine}

  setup do
    # on_exit(fn ->
    #   IO.puts("MakeCoffeeFeatureTest done!")
    # end)

    %{coffee_machine: nil}
  end

  defgiven ~r/^There's a coffee machine with (?<coffee_amount>\d+) doses of coffee in it$/,
           %{coffee_amount: coffee_amount},
           _state do
    coffee_machine = CoffeeMachine.new(%{coffee_amount: parse_integer(coffee_amount)})
    {:ok, %{coffee_machine: coffee_machine}}
  end

  defand ~r/^I as a customer deposit \$(?<money_amount>\d+) inside$/,
         %{money_amount: money_amount},
         %{coffee_machine: coffee_machine} do
    coffee_machine = CoffeeMachine.deposit_money(coffee_machine, parse_integer(money_amount))
    {:ok, %{coffee_machine: coffee_machine}}
  end

  defwhen ~r/^I press the coffee button$/, _vars, %{coffee_machine: coffee_machine} do
    coffee_machine = CoffeeMachine.press_coffee_button!(coffee_machine, :espresso)
    {:ok, %{coffee_machine: coffee_machine}}
  end

  defwhen ~r/^I press the (?<coffee_type>\w+) button$/, %{coffee_type: coffee_type_string}, %{
    coffee_machine: coffee_machine
  } do
    coffe_type =
      case coffee_type_string do
        "coffee" -> :espresso
        type -> String.to_atom(type)
      end

    coffee_machine = CoffeeMachine.press_coffee_button!(coffee_machine, coffe_type)
    {:ok, %{coffee_machine: coffee_machine}}
  end

  defthen ~r/^I should be served a coffee$/, _vars, %{coffee_machine: coffee_machine} do
    {coffee, _coffee_machine} = CoffeeMachine.take_coffee!(coffee_machine)

    assert coffee == %Coffee{type: :espresso}
  end

  defthen ~r/^I should be served (?<coffee_type>\w+)$/, %{coffee_type: coffee_type_string}, %{
    coffee_machine: coffee_machine
  } do
    coffe_type =
      case coffee_type_string do
        "coffee" -> :espresso
        type -> String.to_atom(type)
      end

    {coffee, _coffee_machine} = CoffeeMachine.take_coffee!(coffee_machine)
    assert coffee == %Coffee{type: coffe_type}
  end

  defp parse_integer(value) do
    String.to_integer(value)
  end
end
