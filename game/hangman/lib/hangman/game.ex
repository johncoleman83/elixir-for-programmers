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
end
