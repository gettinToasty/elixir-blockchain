defmodule BlockChain do
  @moduledoc """
  Documentation for BlockChain.
  """

  defstruct blocks: [], message: nil

  def main(message) do
    %BlockChain{ message: message } |> add_block
  end

  def main(message, chain) do
    %{ chain | message: message } |> add_block
  end

  def valid?(chain) do
    all_blocks_valid?(chain) and all_blocks_sequential?(chain)
  end

  defp add_block(blockchain = %BlockChain{ message: message, blocks: [] }) do
    Block.main(message) |> add_block_to_chain(blockchain)
  end
  defp add_block(blockchain = %BlockChain{ message: message, blocks: [head | _rest] }) do
    Block.main(message, head.hash) |> add_block_to_chain(blockchain)
  end

  defp add_block_to_chain(block, %BlockChain{ blocks: blocks }) do
    %BlockChain{ blocks: [block | blocks], message: nil }
  end

  defp all_blocks_valid?(chain) do
    chain.blocks |> Enum.all?(fn(block = %Block{}) -> Block.valid?(block) end)
  end

  defp all_blocks_sequential?(chain) do
    chain.blocks
    |> Enum.chunk(2, 1)
    |> Enum.all?(fn([child, parent]) -> child.parent == parent.hash end)
  end
end
