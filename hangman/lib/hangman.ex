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

  defdelegate new_game(),  to: Game, as: :init_game
  defdelegate tally(game), to: Game, as: :tally

  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    { game, tally(game) }
  end
end
