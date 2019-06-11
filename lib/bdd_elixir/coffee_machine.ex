defmodule BddElixir.CoffeeMachine do
  @moduledoc """
  Provides basic functionality of coffee machines where you can:
  - put coffee in it,
  - deposit money,
  - order coffee, and
  - coffee (if it's ready).
  """
  alias __MODULE__
  alias BddElixir.Coffee

  # how much coffee is in the machine
  # defstruct coffee_amount: 0,
  #           # how much is a coffee
  #           coffee_price: 1,
  #           # how much money is in the machine (after transactions)
  #           money_amount: 0,
  #           # how much money has been deposited
  #           money_amount_deposited: 0,
  #           # is the coffee ready
  #           coffee_ready: nil

  use TypedStruct

  @typedoc """
  Represents a coffee machine
  """
  typedstruct do
    field(:coffee_amount, non_neg_integer(), default: 0)
    field(:coffee_price, non_neg_integer(), default: 1)
    field(:money_amount, non_neg_integer(), default: 0)
    field(:money_amount_deposited, non_neg_integer(), default: 0)
    field(:coffee_ready, Coffee.types() | nil)
  end

  def new(), do: new(%{})

  def new(opts = %{}) do
    %CoffeeMachine{
      coffee_amount: Map.get(opts, :coffee_amount, 0),
      money_amount: Map.get(opts, :money_amount, 0),
      coffee_price: Map.get(opts, :coffee_price, 1),
      money_amount_deposited: 0,
      coffee_ready: nil
    }
  end

  def put_coffee(coffee_machine = %CoffeeMachine{}, coffee_amount)
      when is_integer(coffee_amount) do
    %{coffee_machine | coffee_amount: coffee_amount}
  end

  def deposit_money(coffee_machine = %CoffeeMachine{}, money_amount) do
    %{coffee_machine | money_amount_deposited: money_amount}
  end

  def press_coffee_button!(
        %CoffeeMachine{money_amount_deposited: money_amount_deposited},
        _
      )
      when money_amount_deposited < 1 do
    raise "Not enough money for coffee"
  end

  def press_coffee_button!(
        %CoffeeMachine{coffee_amount: coffee_amount},
        _
      )
      when coffee_amount < 1 do
    raise "Not enough coffee in the machine"
  end

  def press_coffee_button!(
        %CoffeeMachine{coffee_ready: coffee_ready},
        _
      )
      when coffee_ready != nil do
    raise "Coffee is already ready inside the machine"
  end

  def press_coffee_button!(coffee_machine = %CoffeeMachine{}, type) do
    new_coffee_amount = coffee_machine.coffee_amount - 1
    new_money_amount = coffee_machine.money_amount + coffee_machine.coffee_price

    new_money_amount_deposited =
      coffee_machine.money_amount_deposited - coffee_machine.coffee_price

    %CoffeeMachine{
      coffee_machine
      | money_amount: new_money_amount,
        coffee_amount: new_coffee_amount,
        money_amount_deposited: new_money_amount_deposited,
        coffee_ready: Coffee.new(type)
    }
  end

  def take_coffee!(%CoffeeMachine{coffee_ready: nil}) do
    raise "Coffee wasn't ready, first make one!"
  end

  def take_coffee!(coffee_machine = %CoffeeMachine{}) do
    coffee = coffee_machine.coffee_ready
    {coffee, %{coffee_machine | coffee_ready: nil}}
  end
end
