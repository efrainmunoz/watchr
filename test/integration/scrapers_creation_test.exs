defmodule Integration.ScrapersCreationTest do
  use ExUnit.Case

  test "create scrapers for initial pages" do
    Watchr.PagesSupervisor.start_link(:ok)
    Watchr.PagesServer.start_scrapers()
    assert false
  end
end
