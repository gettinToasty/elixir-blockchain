defmodule Block do
  @moduledoc """
  Documentation for Block.
  """

  defstruct hash: nil, nonce: <<Enum.random(35..122)>>, parent: nil, valid: false, iterations: 0

  def main(hash, parent) do
    initialize_block(hash, parent)
    |> find_nonce
  end

  def main(hash) do
    initialize_block(hash)
    |> find_nonce
  end

  defp initialize_block(hash) do
    %Block{ hash: hash }
  end

  defp initialize_block(hash, parent) do
    %Block{ hash: hash, parent: parent }
  end

  defp find_nonce(block = %Block{ hash: hash, nonce: nonce }, count \\ 0) do
    count = count + 1
    cond do
      valid_nonce?(hash, nonce) ->
        %{ block | iterations: count, valid: true, hash: make_hash(hash <> nonce) }
      true -> find_nonce(%{ block | nonce: increment(nonce) }, count)
    end
  end

  defp valid_nonce?(hash, nonce) do
    make_hash(hash <> nonce)
    |> IO.inspect
    |> String.starts_with?("AAA")
  end

  defp make_hash(hash) do
    :crypto.hash(:sha256, hash)
    |> Base.encode32
  end

  defp increment(string) do
    new_val = Enum.random(35..122)

    string <> <<new_val>>
  end
end
