defmodule TextClient.Player do
  @moduledoc """
  Documentation for TextClient.Player
  """

  alias TextClient.State, as: State
  alias TextClient.Worker, as: Worker

  def play(game = %State{ tally: %{ game_state: :initializing } }) do
    continue_with_message(game, "Welcome to Hangman")
  end

  def play(%State{ tally: %{ game_state: :won } }) do
    exit_with_message("We got a winner!")
  end

  def play(%State{ tally: %{ game_state: :lost } }) do
    exit_with_message("We got a loser!")
  end

  def play(game = %State{ tally: %{ game_state: :correct_guess } }) do
    continue_with_message(game, "Correct!")
  end

  def play(game = %State{ tally: %{ game_state: :incorrect_guess } }) do
    continue_with_message(game, "Incorrect.")
  end

  def play(game = %State{ tally: %{ game_state: :already_used } }) do
    continue_with_message(game, "You already guessed that!")
  end

  def continue_with_message(game, message) do
    IO.puts message
    continue(game)
  end

  def continue(game) do
    game
    Worker.display(game)
    Worker.prompt(game)
    |> Worker.make_move()
    |> play()
  end

  defp exit_with_message(message) do
    IO.puts message
    exit(:normal)
  end
end
