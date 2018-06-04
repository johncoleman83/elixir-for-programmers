defmodule TextClient.Worker do
  @moduledoc """
  Documentation for TextClient.Worker
  """

  alias TextClient.State, as: State

  def display(%{ tally: tally }) do
    IO.puts [
      "\n",
      "Word so far: #{tally.word}\n",
      "Guesses left: #{tally.turns_left}\n"
    ]
  end

  def prompt(game = %State{}) do
    prompt_message()
    IO.gets("Your Guess? ")
    |> validate_input(game)
  end

  def make_move(game) do
    { gs, tally } = Hangman.make_move(game.game_service, game.guess)
    %State{
      game |
      game_service: gs,
      tally: tally
    }
  end

  defp validate_input(input, game) do
    guess = String.trim(input)
    cond do
      guess =~ ~r/\A[a-z]?\z/ ->
        Map.put(game, :guess, guess)
      true ->
        prompt(game)
    end
  end

  defp validate_input({ :error, reason }, _) do
    IO.puts("Game ended")
    exit(:normal)
  end

  defp validate_input(:eof, _) do
    IO.puts("Why you no love me?")
    exit(:normal)
  end

  defp prompt_message() do
    IO.puts "Please input a single lowercase character & press enter."
  end

end
