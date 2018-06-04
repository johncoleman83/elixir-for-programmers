defmodule Hangman.State do
  @moduledoc """
  Documentation for Hangman.State
  """

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    word:       nil,
    letters:    nil,
    used:       MapSet.new()
  )

end
