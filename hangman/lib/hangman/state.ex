defmodule Hangman.State do
  @moduledoc """
  Documentation for Hangman.State
  """

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    word:       [],
    letters:    MapSet.new(),
    used:       MapSet.new()
  )

end
