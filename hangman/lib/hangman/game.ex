defmodule Hangman.Game do
  @moduledoc """
  Documentation for Hangman.Game
  """

  # PUBLIC
  def init_game(word) do
    %Hangman.State{
      word:    word |> String.codepoints(),
      letters: word
      |> String.codepoints()
      |> MapSet.new()
    }
  end

  def init_game() do
    Dictionary.start()
    |> Dictionary.random_word()
    |> init_game()
  end

  def make_move(game = %{ game_state: state }, _guess) when state in [ :won, :lost ] do
    game
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      word:       game |> reveal_word(),
      used:       game.used |> used_to_string(MapSet.size(game.used))
    }
  end

  #################################################################################
  # PRIVATE

  defp used_to_string(used, _size = 0) do
    "None"
  end

  defp used_to_string(used, _size) do
    used
    |> MapSet.to_list()
    |> Enum.join(", ")
  end

  defp accept_move(game, guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _already_guessed = false) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(guess, MapSet.member?(game.letters, guess))
  end

  defp score_guess(game, guess, _correct_guess = true) do
    Map.put(game, :letters, MapSet.delete(game.letters, guess))
    |> maybe_won()
  end

  defp score_guess(game = %{ turns_left: 1 }, _guess, _correct_guess = false) do
    %{  game |
        game_state: :lost,
        turns_left: 0
      }
  end

  defp score_guess(game = %{ turns_left: this_turns_left }, _guess, _correct_guess = false) do
    %{  game |
        game_state: :incorrect_guess,
        turns_left: this_turns_left - 1
      }
  end

  defp maybe_won(game) do
    do_maybe_won(game, MapSet.size(game.letters) == 0)
  end

  defp do_maybe_won(game, _won_game = true) do
    Map.put(game, :game_state, :won)
  end

  defp do_maybe_won(game, _won_game = false) do
    Map.put(game, :game_state, :correct_guess)
  end

  defp reveal_word(game) do
    for letter <- game.word do
      letter |> do_reveal_letter(MapSet.member?(game.letters, letter))
    end |> List.to_string()
  end

  defp do_reveal_letter(letter, _unguessed = true),  do: "_"
  defp do_reveal_letter(letter, _unguessed = false), do: letter

end
