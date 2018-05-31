defmodule HangmanGameTest do

  use ExUnit.Case

  alias Hangman.Game, as: Game

  doctest Game

  test "new game returns the structure" do
    game = Game.init_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters |> length > 0

  end

  test "new game word is valid word of lower case letters" do
    game = Game.init_game()

    word = game.letters

    assert word |> length > 0

    for i <- word do
      assert 122 <= String.to_charlist(i) >= 97
    end

  end

end
