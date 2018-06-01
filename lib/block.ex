defmodule Block do
  @moduledoc """
  Documentation for Block.
  """

  defstruct(
    hash: nil,
    nonce: <<Enum.random(35..122)>>,
    parent: "",
    iterations: 0,
    hashed_message: nil
  )

  def main(message, parent) do
    initialize_block(message, parent) |> find_nonce
  end

  def main(message) do
    initialize_block(message) |> find_nonce
  end

  def valid?(block) do
    block |> hashable |> make_hash |> valid_nonce?
  end

  def message_in_block?(block, message) do
    make_hash(message) === block.hashed_message
  end

  defp initialize_block(message) do
    %Block{ hashed_message: make_hash(message) }
  end

  defp initialize_block(message, parent) do
    %Block{ hashed_message: make_hash(message), parent: parent }
  end

  defp find_nonce(block = %Block{ nonce: nonce }, count \\ 0) do
    count = count + 1
    hash = block |> hashable |> make_hash
    cond do
      valid_nonce?(hash) -> %{ block | iterations: count, hash: hash }
      true -> find_nonce(%{ block | nonce: increment(nonce) }, count)
    end
  end

  defp valid_nonce?(hash) do
    hash |> String.starts_with?("AAA")
  end

  defp make_hash(hash) do
    :crypto.hash(:sha256, hash) |> Base.encode32
  end

  defp increment(string) do
    string <> <<Enum.random(35..122)>>
  end

  defp hashable(block) do
    block.hashed_message <> block.parent <> block.nonce
  end
end
