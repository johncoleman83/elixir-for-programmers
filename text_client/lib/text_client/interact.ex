defmodule TextClient.Interact do
  @moduledoc """
  Documentation for TextClient.Interact
  """

  alias TextClient.State, as: State
  alias TextClient.Player, as: Player

  def start() do
    Hangman.new_game()
    |> setup_state()
    |> Player.play()
  end

  def setup_state(game) do
    %State{
      game_service: game,
      tally:        Hangman.tally(game)
    }
  end

end
