defmodule TextClient.State do
  @moduledoc """
  Documentation for TextClient.State
  """

  defstruct(
    game_service: nil,
    tally:        nil,
    guessed:      nil,
    used:         nil
  )

end
