defmodule Dictionary.Wordlist do
  @moduledoc """
  Documentation for Dictionary.Wordlist
  """

  def import_word_list() do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read()
    |> elem(1)
    |> String.split(~r/\n/)
  end

  def random_word(word_list) do
    word_list
    |> Enum.random()
  end

end
