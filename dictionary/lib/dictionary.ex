defmodule Dictionary do
  @moduledoc """
  Documentation for Dictionary.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dictionary.hello
      :world

  """
  def name do
    IO.puts "elixir for programmers method!"
  end

  def random_word do
    word_list()
    |> Enum.random()
  end

  def word_list do
    "./assets/words.txt"
    |> File.read()
    |> elem(1)
    |> String.split(~r/\n/)
  end
end
