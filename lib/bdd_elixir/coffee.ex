defmodule BddElixir.Coffee do
  defstruct type: :espresso

  alias __MODULE__

  @type types() :: :espresso | :macchiato | :americano | :capuccino | :cafe_latte
  @coffee_types [:espresso, :macchiato, :americano, :capuccino, :cafe_latte]

  def new(), do: new(:espresso)

  def new(type) when type in @coffee_types do
    %Coffee{type: type}
  end

  def new(_) do
    coffee_types_string =
      get_coffee_types()
      |> Enum.map(fn a -> Atom.to_string(a) end)
      |> Enum.map(fn a -> String.replace(a, "_", " ") end)
      |> Enum.join(", ")

    raise "Invalid coffee type provided, please select one of the available ones: " <>
            coffee_types_string
  end

  def get_coffee_types() do
    @coffee_types
  end
end
