defmodule Dictionary do
  @moduledoc """
  Documentation for Dictionary.
  """

  @doc """
  Hello world.
      iex> Dictionary.name
      "elixir for programmers method!"
  """
  def name do
    "Dictionary!"
  end

  def random_word do
    word_list()
    |> Enum.random()
  end

  def word_list do
    "../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read()
    |> elem(1)
    |> String.split(~r/\n/)
  end

end
