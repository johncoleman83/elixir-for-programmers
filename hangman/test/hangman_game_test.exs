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
    assert game.turns_left == 6
  end

  test "after various guesses, all guesses are stored in used attribute" do
    game = Game.init_game("narwhal")
    moves = [ "n", "a", "r", "w", "h" ]

    game = Enum.reduce(moves, game, fn (guess, game) ->
      { game, _tally } = Game.make_move(game, guess)
      assert game.game_state == :correct_guess
      assert game.turns_left == 7
      game
    end)
    assert game.used == MapSet.new(["n", "a", "r", "w", "h"])
  end

  test "after entire word guessed, game state is won, with proper game used / letters sets" do
    game = Game.init_game("narwhal")
    moves = [ "n", "a", "r", "w", "h" ]
    game = Enum.reduce(moves, game, fn (guess, game) ->
      { game, _tally } = Game.make_move(game, guess)
      assert game.game_state == :correct_guess
      assert game.turns_left == 7
      game
    end)

    { game, _tally } = Game.make_move(game, "l")
    assert game.used == MapSet.new(["n", "a", "r", "w", "h", "l"])
    assert game.letters == MapSet.new()
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "after game is lost, game state should be lost, with proper game used / letters sets" do
    game = Game.init_game("narwhal")
    moves = [
      { "z", :incorrect_guess, 6 },
      { "b", :incorrect_guess, 5 },
      { "c", :incorrect_guess, 4 },
      { "d", :incorrect_guess, 3 },
      { "e", :incorrect_guess, 2 },
      { "f", :incorrect_guess, 1 },
      { "g", :lost, 0 },
    ]
    game = Enum.reduce(moves, game, fn ({ guess, state, turns_left }, game) ->
      { game, _tally } = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == turns_left
      game
    end)

    assert game.used == MapSet.new(["z", "b", "c", "d", "e", "f", "g"])
    assert game.letters == MapSet.new(["n", "a", "r", "w", "h", "l"])
  end

end
