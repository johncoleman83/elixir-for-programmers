defmodule HangmanGameTest do

  use ExUnit.Case

  alias Hangman.Game, as: Game

  doctest Game

  test "new game returns the structure" do
    game = Game.init_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters |> MapSet.size > 0

  end

  test "new game word is valid word of lower case letters" do
    game = Game.init_game()
    word = game.letters

    all_lower_alpha = for i <- word do
      122 <= String.to_charlist(i) >= 97
    end

    assert word |> MapSet.size > 0
    assert Enum.all?(all_lower_alpha)
  end

  test "state isn't changed once game is won or lost" do
    for state <- [ :won, :lost ] do
      game = Game.init_game()
      game = Map.put(game, :game_state, state)
      assert { ^game, _ } = Game.make_move(game, "n")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.init_game()

    assert MapSet.member?(game.used, "n") == false
    { game, _tally } = Game.make_move(game, "n")
    assert game.game_state != :already_used
    assert MapSet.member?(game.used, "n")
  end

  test "second occurrence of letter is already used" do
    game = Game.init_game()
    { game, _tally } = Game.make_move(game, "n")

    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "n")
    assert game.game_state == :already_used
  end

  test "second occurrence of letter is already used after various other guesses" do
    game = Game.init_game("narwhals")
    # letters = [ "b", "c", "d", "e" ]
    { game, _tally } = Game.make_move(game, "b")
    { game, _tally } = Game.make_move(game, "c")
    { game, _tally } = Game.make_move(game, "d")
    { game, _tally } = Game.make_move(game, "e")

    assert game.game_state == :incorrect_guess
    { game, _tally } = Game.make_move(game, "b")
    assert game.game_state == :already_used
  end

  test "after various guesses, all guesses are stored in used attribute" do
    game = Game.init_game("narwhals")
    # letters = [ "n", "a", "r", "w" ]
    { game, _tally } = Game.make_move(game, "n")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "r")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7

    assert game.used == MapSet.new(["n", "a", "r", "w"])
  end

  test "after entire word guessed, game state is won" do
    game = Game.init_game("narwhal")
    # letters = [ "n", "a", "r", "w", "h", "l" ]

    { game, _tally } = Game.make_move(game, "n")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "r")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "w")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "h")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "l")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "a correct guess is recognized" do
    game = Game.init_game("narwhal")
    { game, _tally } = Game.make_move(game, "n")

    assert game.game_state == :correct_guess
    assert game.turns_left == 7
  end

  test "an incorrect guess is recognized" do
    game = Game.init_game("narwhal")
    { game, _tally } = Game.make_move(game, "z")

    assert game.game_state == :incorrect_guess
    assert game.turns_left == 7
  end

end
