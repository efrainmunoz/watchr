defmodule Watchr.ScrapersSupervisorTest do
  use ExUnit.Case
  doctest Watchr.ScrapersSupervisor

  test "create a dynamic ScrapersSupervisor" do
    Watchr.ScrapersSupervisor.start_link(:ok)
    children = DynamicSupervisor.which_children(Watchr.ScrapersSupervisor)
    assert children == []
  end

  test "start a ScrapersServer" do
    Watchr.ScrapersSupervisor.start_link(:ok)
    Watchr.ScrapersSupervisor.start_scrapers_server()
    children = DynamicSupervisor.count_children(Watchr.ScrapersSupervisor)
    assert children == %{active: 1, specs: 1, supervisors: 0, workers: 1}
  end

  test "start a ScraperSupervisor" do
    Watchr.ScrapersSupervisor.start_link(:ok)

    page = %Watchr.Page{}
    {:ok, content_chain} = Watchr.ContentChain.new()
    Watchr.ScrapersSupervisor.start_scraper_sup(page, content_chain)
    children = DynamicSupervisor.count_children(Watchr.ScrapersSupervisor)
    assert children == %{active: 1, specs: 1, supervisors: 1, workers: 0}
  end

  test "start a ScrapersServer and two ScraperSupervisor" do
    Watchr.ScrapersSupervisor.start_link(:ok)
    Watchr.ScrapersSupervisor.start_scrapers_server()

    page = %Watchr.Page{id: "asdf"}
    {:ok, content_chain} = Watchr.ContentChain.new()
    Watchr.ScrapersServer.create_scraper(page, content_chain)

    page = %{page | id: "qwer"}
    Watchr.ScrapersServer.create_scraper(page, content_chain)
    children = DynamicSupervisor.count_children(Watchr.ScrapersSupervisor)
    assert children == %{active: 3, specs: 3, supervisors: 2, workers: 1}
  end
end
