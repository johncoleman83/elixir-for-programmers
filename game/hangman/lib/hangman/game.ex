defmodule Hangman.Game do
  @moduledoc """
  Documentation for Hangman.Game
  """

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters:    []
  )

  def init_game() do
    %Hangman.Game{
      letters: Dictionary.random_word() |> String.codepoints
    }
  end

  def make_move(game = %{ game_state: state }, _guess) when state in [ :won, :lost ] do
    { game, tally(game) }
  end

  # def make_move(game, guess) do
  #   { game, talley(game) }
  # end

  def tally(game) do
    123
  end
end
