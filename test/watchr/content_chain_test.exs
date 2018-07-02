defmodule Watchr.ContentChainTest do
  use ExUnit.Case
  doctest Watchr.ContentChain

  test "create a new empty Content Chain" do
    {:ok, content_chain} = Watchr.ContentChain.new()
    assert content_chain == %Watchr.ContentChain{}
  end

  test "add content to the chain" do
    {:ok, content_chain} = Watchr.ContentChain.new()
    {:ok, content} = Watchr.Content.new()
    {:ok, new_content_chain} = Watchr.ContentChain.add(content_chain, content)
    assert new_content_chain.contents == [content]
  end
end
