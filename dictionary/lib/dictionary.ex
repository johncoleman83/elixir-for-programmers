defmodule Dictionary do
  @moduledoc """
  Documentation for Dictionary.
  """

  alias Dictionary.Wordlist, as: Wordlist

  @doc """
  Hello world.
      iex> Dictionary.name
      "elixir for programmers method!"
  """
  def name do
    "Dictionary!"
  end

  defdelegate start(),     to: Wordlist, as: :import_word_list
  defdelegate random_word(word_list), to: Wordlist, as: :random_word

end
