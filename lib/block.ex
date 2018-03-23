defmodule Block do
  @moduledoc """
  Documentation for Block.
  """

  defstruct message: nil, nonce: "", parent: nil, valid: false, iterations: 0

  def main(message, parent) do
    initialize_block(message, parent)
    |> find_nonce
  end

  def main(message) do
    initialize_block(message)
    |> find_nonce
  end

  defp initialize_block(message) do
    %Block{ message: message }
  end

  defp initialize_block(message, parent) do
    %Block{ message: message, parent: parent }
  end

  defp find_nonce(block = %Block{ message: message, nonce: nonce }, count \\ 0) do
    count = count + 1
    cond do
      valid_nonce?(message, nonce) ->
        %{ block | iterations: count, valid: true, message: message <> nonce, nonce: nil }
      true -> find_nonce(%{ block | nonce: increment(nonce) }, count)
    end
  end

  defp valid_nonce?(message, nonce) do
    make_hash(message <> nonce)
    |> String.starts_with?("AAA")
  end

  defp make_hash(message) do
    :crypto.hash(:sha256, message)
    |> Base.encode32
  end

  defp increment(string) do
    new_val = Enum.random(35..122)

    string <> <<new_val>>
  end
end
