defmodule Watchr.ScraperServerTest do
  use ExUnit.Case
  doctest Watchr.ScraperServer

  test "create a new ScraperServer" do
    {:ok, content_chain} = Watchr.ContentChain.new()
    {:ok, pid} = Watchr.ScraperServer.start_link(content_chain)
    assert Process.alive?(pid)
  end
end
