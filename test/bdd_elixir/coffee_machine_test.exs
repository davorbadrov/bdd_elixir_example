defmodule BDDElixirTest.CoffeeMachine do
  use ExUnit.Case
  alias BddElixir.{CoffeeMachine, Coffee}

  test "Coffee machine can make an espresso when there's enough coffee and money deposited" do
    # Setup (Given)
    coffee_machine =
      CoffeeMachine.new()
      |> CoffeeMachine.put_coffee(1)
      |> CoffeeMachine.deposit_money(1)

    # Calls/Actions (When)
    coffee_machine = CoffeeMachine.press_coffee_button!(coffee_machine, :espresso)

    # Assertions (Then)
    {coffee, _coffee_machine} = CoffeeMachine.take_coffee!(coffee_machine)
    assert coffee == %Coffee{type: :espresso}
  end

  test "Super short espresso test" do
    {coffee, _coffee_machine} =
      CoffeeMachine.new()
      |> CoffeeMachine.put_coffee(1)
      |> CoffeeMachine.deposit_money(1)
      |> CoffeeMachine.press_coffee_button!(:espresso)
      |> CoffeeMachine.take_coffee!()

    assert coffee == %Coffee{type: :espresso}
  end

  test "When coffe is taken the coffee slot should be empty" do
    {_coffee, coffee_machine} =
      CoffeeMachine.new()
      |> CoffeeMachine.put_coffee(1)
      |> CoffeeMachine.deposit_money(1)
      |> CoffeeMachine.press_coffee_button!(:espresso)
      |> CoffeeMachine.take_coffee!()

    assert coffee_machine.coffee_ready == nil
  end

  test "Coffee machine cannot make a coffe if there's no money" do
    coffee_machine = CoffeeMachine.new(%{coffee_amount: 10})

    assert_raise(RuntimeError, "Not enough money for coffee", fn ->
      CoffeeMachine.press_coffee_button!(coffee_machine, :espresso)
    end)
  end

  test "Coffee machine cannot make a coffe if it's empty" do
    coffee_machine =
      CoffeeMachine.new(%{coffee_amount: 0})
      |> CoffeeMachine.deposit_money(1)

    assert_raise(RuntimeError, "Not enough coffee in the machine", fn ->
      CoffeeMachine.press_coffee_button!(coffee_machine, :espresso)
    end)
  end

  test "Coffee machine cannot provide coffe if you didn't order it" do
    coffee_machine =
      CoffeeMachine.new(%{coffee_amount: 10})
      |> CoffeeMachine.deposit_money(1)

    assert_raise(RuntimeError, "Coffee wasn't ready, first make one!", fn ->
      CoffeeMachine.take_coffee!(coffee_machine)
    end)
  end
end
