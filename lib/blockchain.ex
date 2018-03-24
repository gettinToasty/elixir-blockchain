defmodule BlockChain do
  @moduledoc """
  Documentation for BlockChain.
  """

  defstruct blocks: [], prev_block_hash: nil

  def main(arg) when is_bitstring(arg) do
    %BlockChain{ prev_block_hash: arg }
    |> add_block
  end

  def main(arg) do
    arg |> add_block
  end

  defp add_block(blockchain = %BlockChain{ prev_block_hash: hash }) do
    Block.main(hash)
    |> add_block_to_chain(blockchain)
  end

  defp add_block_to_chain(
    block = %Block{ hash: hash },
    %BlockChain{ blocks: blocks }
  ) do
    %BlockChain{ blocks: [block | blocks], prev_block_hash: hash }
  end
end
