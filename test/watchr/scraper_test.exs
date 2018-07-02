defmodule Watchr.ScraperTest do
  use ExUnit.Case
  doctest Watchr.Scraper

  test "start a new scraper process" do
    page = %Watchr.Page{}
    {:ok, pid} = Watchr.Scraper.start_link(page)
    assert Process.alive?(pid)
  end

  test "run a scraper" do
    page = %Watchr.Page{}
    {:ok, pid} = Watchr.Scraper.start_link(page)
    stored_page = Watchr.Scraper.run(pid)
    assert stored_page == page
  end
end
