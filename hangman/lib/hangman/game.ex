defmodule Hangman.Game do
  @moduledoc """
  Documentation for Hangman.Game
  """

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    word:       "",
    letters:    MapSet.new(),
    used:       MapSet.new()
  )

  def init_game(word) do
    %Hangman.Game{
      word:    word,
      letters: word
      |> String.codepoints
      |> MapSet.new()
    }
  end

  def init_game() do
    Dictionary.random_word()
    |> init_game()
  end

  def make_move(game = %{ game_state: state }, _guess) when state in [ :won, :lost ] do
    #game
    { game, tally(game) }
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    #game
    { game, tally(game) }
  end

  def accept_move(game, guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _already_guessed = false) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(guess, MapSet.member?(game.letters, guess))
  end

  def score_guess(game, guess, _correct_guess = true) do
    Map.put(game, :letters, MapSet.delete(game.letters, guess))
    |> maybe_won()
  end

  def score_guess(game = %{ turns_left: 1 }, _guess, _correct_guess = false) do
    %{  game |
        game_state: :lost,
        turns_left: 0
      }
  end

  def score_guess(game = %{ turns_left: this_turns_left }, _guess, _correct_guess = false) do
    %{  game |
        game_state: :incorrect_guess,
        turns_left: this_turns_left - 1
      }
  end

  def maybe_won(game) do
    maybe_won_do(game, MapSet.size(game.letters) == 0)
  end

  def maybe_won_do(game, _won_game = true) do
    Map.put(game, :game_state, :won)
  end

  def maybe_won_do(game, _won_game = false) do
    Map.put(game, :game_state, :correct_guess)
  end

  def tally(game) do
    123
  end
end
