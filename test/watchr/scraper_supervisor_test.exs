defmodule Watchr.ScraperSupervisorTest do
  use ExUnit.Case
  doctest Watchr.ScraperSupervisor

  test "create a new ScraperSupervisor" do
    page = %Watchr.Page{}
    {:ok, content_chain} = Watchr.ContentChain.new()
    {:ok, pid} = Watchr.ScraperSupervisor.start_link({page, content_chain})
    assert Process.alive?(pid)
  end
end
