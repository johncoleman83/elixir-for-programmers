defmodule Procs do
  def greeter(count) do
    receive do
      { :reset } ->
        greeter(count - count)
      { :boom, reason } ->
        exit(reason)
      { :add, n } ->
        greeter(count + n)
      { :msg, msg } ->
        IO.puts "#{count} #{msg}"
        greeter(count + 1)
    end
  end
end
