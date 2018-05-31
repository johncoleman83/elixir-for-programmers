defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  alias Hangman.Game, as: Game

  @doc """
  Hello World.
      iex> Hangman.name
      "Hangman module!"
  """
  def name do
    "Hangman module!"
  end

  defdelegate new_game(), to: Game, as: :init_game
end
