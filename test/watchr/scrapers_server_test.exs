defmodule Watchr.ScrapersServerTest do
  use ExUnit.Case
  doctest Watchr.ScrapersServer

  test "start a new ScrapersServer" do
    {:ok, pid} = Watchr.ScrapersServer.start_link(:ok)
    assert Process.alive?(pid)
  end

  test "start a new ScraperSupervisor" do
    Watchr.ScrapersSupervisor.start_link(:ok)
    Watchr.ScrapersSupervisor.start_scrapers_server()

    page = %Watchr.Page{}
    {:ok, content_chain} = Watchr.ContentChain.new()

    {:ok, pid} = Watchr.ScrapersServer.create_scraper(page, content_chain)
    assert Process.alive?(pid)
  end

  test "get the ScraperServer pid for a given Page id" do
    Watchr.ScrapersSupervisor.start_link(:ok)
    Watchr.ScrapersSupervisor.start_scrapers_server()

    page = %Watchr.Page{id: "asdf"}
    {:ok, content_chain} = Watchr.ContentChain.new()
    Watchr.ScrapersServer.create_scraper(page, content_chain)

    {:ok, pid} = Watchr.ScrapersServer.get_pid(page.id)
    assert Process.alive?(pid)
  end
end
