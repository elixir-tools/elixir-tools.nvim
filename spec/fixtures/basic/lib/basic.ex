defmodule Basic do
  def run do
    Enum.map([:one, :two], &Function.identity/1)
  end
end
